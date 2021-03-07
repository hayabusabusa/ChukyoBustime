//
//  ToStationViewModel.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import SwiftDate
import RxSwift
import RxCocoa

// MARK: - Protocols

protocol ToStationViewModelInputs {
    /// Call when the view did load.
    func viewDidLoad()
    
    /// Call when the application will enter foreground.
    func willEnterForeground()
    
    /// Call when the setting bar button item is tapped.
    func settingButtonTapped()
    
    /// Call when the calendar button on the state view is tapped.
    func calendarButtonTapped()
    
    /// Call when the time table button on the state view is tapped.
    func timeTableButtonTapped()
}

protocol ToStationViewModelOutputs {
    /// Emits `State` object that should be used to show state of `StateView`.
    var state: Driver<StateView.State> { get }
    
    /// Emits void event to present `SettingViewController`.
    var presentSetting: Signal<Void> { get }
    
    /// Emits a URL that should be used to present `SFSafariViewController`.
    var presentSafari: Signal<URL> { get }
    
    /// Return child view models initialized in this view model.
    var childViewModels: ToStationViewModel.ChildViewModels { get }
}

protocol ToStationViewModelType {
    var input: ToStationViewModelInputs { get }
    var output: ToStationViewModelOutputs { get }
}

// MARK: - ViewModel

final class ToStationViewModel: ToStationViewModelInputs, ToStationViewModelOutputs {
    
    typealias ChildViewModels = (diagramViewModel: DiagramViewModel, busListViewModel: BusListViewModel, countdownViewModel: CountdownViewModel)
    
    // MARK: Dependency
    
    private let model: ToStationModel
    
    // MARK: Outputs
    
    let state: Driver<StateView.State>
    let presentSafari: Signal<URL>
    let presentSetting: Signal<Void>
    let childViewModels: ChildViewModels
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    private let stateRelay: BehaviorRelay<StateView.State> // Show indicator and hide scroll view
    private let countupRelay: PublishRelay<Void>
    private let diagramRelay: BehaviorRelay<String>
    private let busTimesRelay: BehaviorRelay<[BusTime]>
    private let presentSafariRelay: PublishRelay<URL>
    private let presentSettingRelay: PublishRelay<Void>
    
    // MARK: Initializer
    
    init(model: ToStationModel = ToStationModelImpl()) {
        self.model = model
        self.stateRelay = .init(value: .loading)
        self.countupRelay = .init()
        self.diagramRelay = .init(value: "")
        self.busTimesRelay = .init(value: [])
        self.presentSafariRelay = .init()
        self.presentSettingRelay = .init()
        
        state = stateRelay.asDriver()
        presentSafari = presentSafariRelay.asSignal()
        presentSetting = presentSettingRelay.asSignal()
        
        // NOTE: 依存する ViewModel を生成
        let diagram = diagramRelay.asDriver()
        let busTimes = busTimesRelay.asDriver()
        let diagramViewModel = DiagramViewModel(dependency: .init(diagramNameDriver: diagram))
        let busListViewModel = BusListViewModel(dependency: .init(destination: .station, busTimes: busTimes, model: BusListModelImpl()))
        let countdownViewModel = CountdownViewModel(dependency: .init(busTimes: busTimes, destination: .station, countupRelay: countupRelay))
        childViewModels = ChildViewModels(diagramViewModel: diagramViewModel, busListViewModel: busListViewModel, countdownViewModel: countdownViewModel)
        
        // NOTE: カウントアップのイベントが流れてきたら直近の時刻を削除する
        // 一覧が全てなくなった場合は運行終了したことを画面に表示する
        countupRelay
            .subscribe(onNext: { [weak self] in
                var busTimes = self?.busTimesRelay.value ?? []
                
                busTimes.popFirst()
                
                if busTimes.isEmpty {
                    self?.stateRelay.accept(.empty)
                }
                self?.busTimesRelay.accept(busTimes)
            })
            .disposed(by: disposeBag)
    }
    
    // MARK: Inputs
    
    func viewDidLoad() {
        let today = Date()
        model.getBusTimes(at: today)
            .subscribe(onSuccess: { [weak self] result in
                self?.diagramRelay.accept(result.busDate.diagramName)
                self?.busTimesRelay.accept(result.busTimes)
                self?.stateRelay.accept(result.busTimes.isEmpty ? .empty : .none) // Hide indicator and show scroll view
            }, onFailure: { [weak self] _ in
                self?.stateRelay.accept(.error)
            })
            .disposed(by: disposeBag)
    }
    
    func settingButtonTapped() {
        presentSettingRelay.accept(())
    }
    
    func willEnterForeground() {
        let now = DateInRegion(Date(), region: .current)
        let second = now.hour * 3600 + now.minute + 60 + now.second
        let newArray = busTimesRelay.value.filter { $0.second >= second }
        busTimesRelay.accept(newArray)
    }
    
    func calendarButtonTapped() {
        model.getPdfUrl().asSignal(onErrorSignalWith: .empty())
            .map { URL(string: $0.calendar) }
            .compactMap { $0 }
            .emit(to: presentSafariRelay)
            .disposed(by: disposeBag)
    }
    
    func timeTableButtonTapped() {
        model.getPdfUrl().asSignal(onErrorSignalWith: .empty())
            .map { URL(string: $0.timeTable) }
            .compactMap { $0 }
            .emit(to: presentSafariRelay)
            .disposed(by: disposeBag)
    }
}

extension ToStationViewModel: ToStationViewModelType {
    var input: ToStationViewModelInputs { return self }
    var output: ToStationViewModelOutputs { return self }
}
