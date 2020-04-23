//
//  ToStationModel.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra
import RxSwift

// MARK: - Interface

protocol ToStationModel: AnyObject {
    func getBusTimes(at date: Date) -> Single<(busDate: BusDate, busTimes: [BusTime])>
    func getPdfUrl() -> Single<PdfUrl>
}

// MARK: - Implementation

class ToStationModelImpl: ToStationModel {
    
    // MARK: Dependency
    
    private let firestoreRepository: FirestoreRepository
    private let localCacheRepository: LocalCacheRepository
    private let remoteConfigProvider: RemoteConfigProvider
    
    // MARK: Initializer
    
    init(firestoreRepository: FirestoreRepository = FirestoreRepositoryImpl(),
         localCacheRepository: LocalCacheRepository = LocalCacheRepositoryImpl(),
         remoteConfigProvider: RemoteConfigProvider = RemoteConfigProvider.shared) {
        self.firestoreRepository = firestoreRepository
        self.localCacheRepository = localCacheRepository
        self.remoteConfigProvider = remoteConfigProvider
    }
    
    // MARK: Firestore
    
    /// 時刻表のデータをFirestoreから取得する.
    /// - Parameter date: 取得するタイミングの`Date`.
    func getBusTimes(at date: Date) -> Single<(busDate: BusDate, busTimes: [BusTime])> {
        return firestoreRepository.getBusTimes(at: date, destination: .toStation)
            .flatMap { value -> Single<(busDate: BusDate, busTimes: [BusTime])> in
                // NOTE: キャッシュを保存して完了した後にFirestoreから取得したものを流す.
                return self.localCacheRepository.saveCache(of: .toStation, date: date, busDate: value.busDate, busTimes: value.busTimes)
                    .andThen(Single.just((busDate: value.busDate, busTimes: value.busTimes)))
                    .translate(BusDateAndBusTimesTranslator())
            }
    }
    
    // MARK: Remote Config
    
    func getPdfUrl() -> Single<PdfUrl> {
        return remoteConfigProvider
            .getConfigValue(for: .pdfUrl, configType: RCPdfUrlEntity.self)
            .translate(PdfUrlTranslator())
    }
}
