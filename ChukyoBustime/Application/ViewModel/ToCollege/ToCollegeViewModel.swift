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

final class ToCollegeViewModel {
    
    // MARK: Dependency
    
    private let model: ToCollegeModel
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(model: ToCollegeModel = ToCollegeModelImpl()) {
        self.model = model
    }
}

extension ToCollegeViewModel: ViewModelType {
    
    typealias Children = (diagramViewModel: DiagramViewModel,
                          countdownViewModel: CountdownViewModel,
                          busListViewModel: BusListViewModel)
    
    // MARK: I/O
    
    struct Input {
        let foregroundSignal: Signal<Void>
        let calendarButtonDidTap: Signal<Void>
        let timeTableButtonDidTap: Signal<Void>
        let settingBarButtonDidTap: Signal<Void>
    }
    
    struct Output {
        let children: Children
        let stateDriver: Driver<StateView.State>
        let presentSettingSignal: Signal<Void>
        let presentSafariSignal: Signal<URL>
    }
    
    // MARK: Transform I/O
    
    func transform(input: ToCollegeViewModel.Input) -> ToCollegeViewModel.Output {
        let diagramRelay: BehaviorRelay<String> = .init(value: "")
        let busTimesRelay: BehaviorRelay<[BusTime]> = .init(value: [])
        let countupRelay: PublishRelay<Void> = .init()
        let stateRelay: BehaviorRelay<StateView.State> = .init(value: .loading) // Show indicator and hide scroll view
        let presentSafariRelay: PublishRelay<URL> = .init()
        
        let now = Date()
        model.getBusTimes(at: now)
            .subscribe(onSuccess: { result in
                diagramRelay.accept(result.busDate.diagramName)
                busTimesRelay.accept(result.busTimes)
                stateRelay.accept(result.busTimes.isEmpty ? .empty : .none) // Hide indicator and show scroll view
            }, onFailure: { _ in
                stateRelay.accept(.error)
            })
            .disposed(by: disposeBag)
        
        // NOTE: On tap state view button.
        let pdfURLSignal = model.getPdfUrl().asSignal(onErrorSignalWith: .empty())
        input.calendarButtonDidTap
            .flatMapLatest { pdfURLSignal }
            .map { URL(string: $0.calendar) }
            .compactMap { $0 }
            .emit(to: presentSafariRelay)
            .disposed(by: disposeBag)
        input.timeTableButtonDidTap
            .flatMapLatest { pdfURLSignal }
            .map { URL(string: $0.timeTable) }
            .compactMap { $0 }
            .emit(to: presentSafariRelay)
            .disposed(by: disposeBag)
        // NOTE: Back from background, Update current busTime array.
        input.foregroundSignal
            .emit(onNext: {
                let now = DateInRegion(Date(), region: .current)
                let second = now.hour * 3600 + now.minute + 60 + now.second
                let newArray = busTimesRelay.value.filter { $0.second >= second }
                busTimesRelay.accept(newArray)
            })
            .disposed(by: disposeBag)
        // NOTE: Update current busTime array.
        countupRelay.asDriver(onErrorDriveWith: .empty())
            .drive(onNext: {
                var busTimes = busTimesRelay.value
                if busTimes.isEmpty {
                    busTimesRelay.accept([])
                    stateRelay.accept(.empty) // Show empty state
                } else {
                    busTimes.removeFirst()
                    busTimesRelay.accept(busTimes)
                }
            })
            .disposed(by: disposeBag)
        
        let diagramDriver: Driver<String> = diagramRelay.asDriver()
        let busTimesDriver: Driver<[BusTime]> = busTimesRelay.asDriver()
        let diagramViewModel = DiagramViewModel(dependency: DiagramViewModel.Dependency(diagramNameDriver: diagramDriver))
        let countdownViewModel = CountdownViewModel(dependency: CountdownViewModel.Dependency(busTimes: busTimesDriver, destination: .college, countupRelay: countupRelay))
        let busListViewModel = BusListViewModel(dependency: BusListViewModel.Dependency(destination: .college, busTimesDriver: busTimesDriver, model: BusListModelImpl()))
        
        return Output(children: Children(diagramViewModel: diagramViewModel,
                                         countdownViewModel: countdownViewModel,
                                         busListViewModel: busListViewModel),
                      stateDriver: stateRelay.asDriver(),
                      presentSettingSignal: input.settingBarButtonDidTap,
                      presentSafariSignal: presentSafariRelay.asSignal())
    }
}

