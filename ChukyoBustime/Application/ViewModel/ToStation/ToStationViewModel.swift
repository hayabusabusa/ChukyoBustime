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

final class ToStationViewModel {
    
    // MARK: Dependency
    
    private let model: ToStationModel
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(model: ToStationModel = ToStationModelImpl()) {
        self.model = model
    }
}

extension ToStationViewModel: ViewModelType {
    
    typealias Children = (diagramViewModel: DiagramViewModel,
                          countdownViewModel: CountdownViewModel,
                          busListViewModel: BusListViewModel)
    
    // MARK: I/O
    
    struct Input {
        let foregroundSignal: Signal<Void>
        let settingBarButtonDidTap: Signal<Void>
    }
    
    struct Output {
        let children: Children
        let stateDriver: Driver<StateView.State>
        let presentSettingSignal: Signal<Void>
    }
    
    // MARK: Transform I/O
    
    func transform(input: ToStationViewModel.Input) -> ToStationViewModel.Output {
        let diagramRelay: BehaviorRelay<String> = .init(value: "")
        let busTimesRelay: BehaviorRelay<[BusTime]> = .init(value: [])
        let countupRelay: PublishRelay<Void> = .init()
        let stateRelay: BehaviorRelay<StateView.State> = .init(value: .loading) // Show indicator and hide scroll view
        
        let now = Date()
        model.getBusTimes(at: now)
            .subscribe(onSuccess: { result in
                diagramRelay.accept(result.busDate.diagramName)
                busTimesRelay.accept(result.busTimes)
                stateRelay.accept(result.busTimes.isEmpty ? .empty : .none) // Hide indicator and show scroll view
            }, onError: { error in
                print(error)
            })
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
                } else {
                    busTimes.removeFirst()
                    busTimesRelay.accept(busTimes)
                }
            })
            .disposed(by: disposeBag)
        
        let diagramDriver: Driver<String> = diagramRelay.asDriver()
        let busTimesDriver: Driver<[BusTime]> = busTimesRelay.asDriver()
        let diagramViewModel = DiagramViewModel(dependency: diagramDriver)
        let countdownViewModel = CountdownViewModel(dependency: CountdownViewModel.Dependency(destination: .station, countupRelay: countupRelay, busTimesDriver: busTimesDriver))
        let busListViewModel = BusListViewModel(dependency: BusListViewModel.Dependency(destination: .station, busTimesDriver: busTimesDriver))
        
        return Output(children: Children(diagramViewModel: diagramViewModel,
                                         countdownViewModel: countdownViewModel,
                                         busListViewModel: busListViewModel),
                      stateDriver: stateRelay.asDriver(),
                      presentSettingSignal: input.settingBarButtonDidTap)
    }
}
