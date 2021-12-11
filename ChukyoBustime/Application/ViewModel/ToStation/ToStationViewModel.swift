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
    
    private let model: ToDestinationModel
    
    // MARK: Outputs
    
    // インジケーターの表示と ScrollView の表示、非表示を行う.
    let state: Driver<StateView.State>
    let presentSafari: Signal<URL>
    let presentSetting: Signal<Void>
    let childViewModels: ChildViewModels
    
    // MARK: Propreties
    
    private let presentSettingRelay: PublishRelay<Void>
    
    // MARK: Initializer
    
    init(model: ToDestinationModel = ToDestinationModelImpl(for: .toStation)) {
        self.model = model
        self.presentSettingRelay = .init()
        
        // NOTE: 依存する ViewModel を生成
        let diagramStream = model.diagramStream.asDriver(onErrorDriveWith: .empty())
        let busTimesStream = model.busTimesStream.asDriver(onErrorDriveWith: .empty())
        let countupRelay = model.countupRelay
        let diagramViewModel = DiagramViewModel(dependency: .init(diagramNameDriver: diagramStream))
        let busListViewModel = BusListViewModel(dependency: .init(destination: .station, busTimes: busTimesStream, model: BusListModelImpl()))
        let countdownViewModel = CountdownViewModel(dependency: .init(busTimes: busTimesStream, destination: .station, countupRelay: countupRelay))
        childViewModels = ChildViewModels(diagramViewModel: diagramViewModel, busListViewModel: busListViewModel, countdownViewModel: countdownViewModel)
        
        state = Observable
            .combineLatest(model.isLoadingStream, model.busTimesStream) { isLoading, busTimes -> StateView.State in
                guard !isLoading else {
                    return .loading
                }
                // NOTE: 一覧が全てなくなった場合は運行終了したことを画面に表示する
                guard !busTimes.isEmpty else {
                    return .empty
                }
                return .none
            }
            .asDriver(onErrorDriveWith: .empty())
        presentSafari = model.pdfURLStream
            .map { URL(string: $0) }
            .compactMap { $0 }
            .asSignal(onErrorSignalWith: .empty())
        presentSetting = presentSettingRelay.asSignal()
    }
    
    // MARK: Inputs
    
    func viewDidLoad() {
        let today = Date()
        model.getBusTimes(at: today)
    }
    
    func settingButtonTapped() {
        presentSettingRelay.accept(())
    }
    
    func willEnterForeground() {
        model.updateBusTimes()
    }
    
    func calendarButtonTapped() {
        model.getPDFURL(for: .calendar)
    }
    
    func timeTableButtonTapped() {
        model.getPDFURL(for: .timeTable)
    }
}

extension ToStationViewModel: ToStationViewModelType {
    var input: ToStationViewModelInputs { return self }
    var output: ToStationViewModelOutputs { return self }
}
