//
//  ToCollegeViewModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/02/06.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import SwiftDate
import RxSwift
import RxCocoa

// MARK: - Protocols

protocol ToCollegeViewModelInputs {
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

protocol ToCollegeViewModelOutputs {
    /// Emits `State` object that should be used to show state of `StateView`.
    var state: Driver<StateView.State> { get }
    
    /// Emits void event to present `SettingViewController`.
    var presentSetting: Signal<Void> { get }
    
    /// Emits a URL that should be used to present `SFSafariViewController`.
    var presentSafari: Signal<URL> { get }
    
    /// Return child view models initialized in this view model.
    var childViewModels: ToCollegeViewModel.ChildViewModels { get }
}

protocol ToCollegeViewModelType {
    var input: ToCollegeViewModelInputs { get }
    var output: ToCollegeViewModelOutputs { get }
}

// MARK: - ViewModel

final class ToCollegeViewModel: ToCollegeViewModelInputs, ToCollegeViewModelOutputs {
    
    typealias ChildViewModels = (diagramViewModel: DiagramViewModel, busListViewModel: BusListViewModel, countdownViewModel: CountdownViewModel)
    
    // MARK: Dependency
    
    private let model: ToDestinationModel
    
    // MARK: Outputs
    
    let state: Driver<StateView.State>
    let presentSafari: Signal<URL>
    let presentSetting: Signal<Void>
    let childViewModels: ChildViewModels
    
    // MARK: Propreties
    
    private let presentSettingRelay: PublishRelay<Void>
    
    // MARK: Initializer
    
    init(model: ToDestinationModel = ToDestinationModelImpl(for: .toCollege)) {
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
            .zip(model.isLoadingStream, model.busTimesStream)
            .map { isLoading, busTimes -> StateView.State in
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
            .compactMap { URL(string: $0) }
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

extension ToCollegeViewModel: ToCollegeViewModelType {
    var input: ToCollegeViewModelInputs { return self }
    var output: ToCollegeViewModelOutputs { return self }
}
