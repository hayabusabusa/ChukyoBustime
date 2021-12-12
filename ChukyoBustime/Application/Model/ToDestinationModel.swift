//
//  ToDestinationModel.swift
//  ChukyoBustime
//
//  Created by Shunya Yamada on 2021/10/09.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra
import RxRelay
import RxSwift
import SwiftDate

// MARK: - Interface

protocol ToDestinationModel: AnyObject {
    /// ロード中かどうかを流す `Observable<Bool>`
    var isLoadingStream: Observable<Bool> { get }
    
    /// 発生したエラーを流す `Observable<Error>`
    var errorStream: Observable<Error> { get }
    
    /// ダイヤ名を流す `Observable<String>`
    ///
    /// ダイヤ名の表示を行なっている `DiagramViewModel ` に渡してあげる.
    var diagramStream: Observable<String> { get }
    
    /// Firestore から取得した時刻表のデータ一覧を流す `Observable<[BusTime]>`
    ///
    /// 一覧の表示を行なっている `BusListViewModel` に渡してあげる.
    var busTimesStream: Observable<[BusTime]> { get }
    
    /// Remote Config から取得した PDF の URL 文字列を流す `Observable<String>`
    var pdfURLStream: Observable<String> { get }
    
    /// タイマーのカウントアップのイベントを流すための `PublishRelay<Void>`
    ///
    /// タイマーの処理を行なっている `CountdownViewModel` に渡してあげる.
    var countupRelay: PublishRelay<Void> { get }
    
    /// 時刻表のデータをFirestoreから取得する.
    /// - Parameter date: 取得するタイミングの`Date`.
    func getBusTimes(at date: Date)
    
    /// 現在の時間で時刻表のデータを更新する.
    ///
    /// バックグラウンドから戻ってきた時などに実行する.
    func updateBusTimes()
    
    /// Remote Config から PDF の URL を取得する.
    func getPDFURL(for type: PDFURLType)
}

// MARK: - Implementation

final class ToDestinationModelImpl: ToDestinationModel {
    
    // MARK: Dependency
    
    private let destination: BusDestination
    private let firestoreRepository: FirestoreRepository
    private let localCacheRepository: LocalCacheRepository
    private let remoteConfigProvider: RemoteConfigProvider
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let isLoadingRelay: BehaviorRelay<Bool>
    private let errorRelay: PublishRelay<Error>
    private let diagramRelay: BehaviorRelay<String>
    private let busTimesRelay: BehaviorRelay<[BusTime]>
    private let calendarPDFURLRelay: PublishRelay<String>
    private let timeTablePDFURLRelay: PublishRelay<String>
    
    // MARK: Output
    
    let isLoadingStream: Observable<Bool>
    let errorStream: Observable<Error>
    let countupRelay: PublishRelay<Void>
    let diagramStream: Observable<String>
    let busTimesStream: Observable<[BusTime]>
    let pdfURLStream: Observable<String>
    
    // MARK: Initializer
    
    init(for destination: BusDestination,
         firestoreRepository: FirestoreRepository = FirestoreRepositoryImpl(),
         localCacheRepository: LocalCacheRepository = LocalCacheRepositoryImpl(),
         remoteConfigProvider: RemoteConfigProvider = RemoteConfigProvider.shared) {
        self.destination = destination
        self.firestoreRepository = firestoreRepository
        self.localCacheRepository = localCacheRepository
        self.remoteConfigProvider = remoteConfigProvider
        
        self.isLoadingRelay = .init(value: true)
        self.isLoadingStream = isLoadingRelay.asObservable()
        self.errorRelay = .init()
        self.errorStream = errorRelay.asObservable()
        self.countupRelay = .init()
        self.diagramRelay = .init(value: "")
        self.diagramStream = diagramRelay.asObservable()
        self.busTimesRelay = .init(value: [])
        self.busTimesStream = busTimesRelay.asObservable()
        self.calendarPDFURLRelay = .init()
        self.timeTablePDFURLRelay = .init()
        self.pdfURLStream = Observable.merge([calendarPDFURLRelay.asObservable(),
                                              timeTablePDFURLRelay.asObservable()])
        
        // NOTE: カウントアップのイベントが流れてきたら直近の時刻を削除する
        countupRelay
            .subscribe(onNext: { [weak self] in
                var busTimes = self?.busTimesRelay.value ?? []
                busTimes.popFirst()
                
                self?.busTimesRelay.accept(busTimes)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Firestore
    
    func getBusTimes(at date: Date) {
        firestoreRepository
            .getBusTimes(at: date, destination: destination)
            .flatMap { value -> Single<(busDate: BusDate, busTimes: [BusTime])> in
                // NOTE: キャッシュを保存して完了した後にFirestoreから取得したものを流す.
                return self.localCacheRepository.saveCache(of: .toStation, date: date, busDate: value.busDate, busTimes: value.busTimes)
                    .andThen(Single.just((busDate: value.busDate, busTimes: value.busTimes)))
                    .translate(BusDateAndBusTimesTranslator())
            }
            .subscribe(onSuccess: { [weak self] value in
                self?.isLoadingRelay.accept(false)
                self?.diagramRelay.accept(value.busDate.diagramName)
                self?.busTimesRelay.accept(value.busTimes)
            }, onFailure: { [weak self] error in
                self?.isLoadingRelay.accept(false)
                self?.errorRelay.accept(error)
            })
            .disposed(by: disposeBag)
    }
    
    func updateBusTimes() {
        let now = DateInRegion(Date(), region: .current)
        let second = now.hour * 3600 + now.minute * 60 + now.second
        let newArray = busTimesRelay.value.filter { $0.second >= second }
        busTimesRelay.accept(newArray)
    }
    
    // MARK: Remote Config
    
    func getPDFURL(for type: PDFURLType) {
        remoteConfigProvider
            .getConfigValue(for: .pdfUrl, configType: RCPdfUrlEntity.self)
            .translate(PdfUrlTranslator())
            .subscribe(onSuccess: { [weak self] value in
                // NOTE: PDF の種類に応じて URL を流す.
                switch type {
                case .calendar:
                    self?.calendarPDFURLRelay.accept(value.calendar)
                case .timeTable:
                    self?.timeTablePDFURLRelay.accept(value.timeTable)
                }
            }, onFailure: { _ in
                // NOTE: 必要ならエラーハンドリングをする( 現状 Remote Config のエラーは表示させない ).
            })
            .disposed(by: disposeBag)
    }
}
