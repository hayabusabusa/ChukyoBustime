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
        let settingBarButtonDidTap: Signal<Void>
    }
    
    struct Output {
        let children: Children
        let isLoadingDriver: Driver<Bool>
        let presentSettingSignal: Signal<Void>
    }
    
    // MARK: Transform I/O
    
    func transform(input: ToCollegeViewModel.Input) -> ToCollegeViewModel.Output {
        let diagramRelay: BehaviorRelay<String> = .init(value: "")
        let busTimesRelay: BehaviorRelay<[BusTime]> = .init(value: [])
        let countupRelay: PublishRelay<Void> = .init()
        let isLoadingRelay: BehaviorRelay<Bool> = .init(value: true) // Show indicator and hide scroll view
        
        let now = Date()
        model.getBusTimes(at: now)
            .subscribe(onSuccess: { result in
                diagramRelay.accept(result.busDate.diagramName)
                busTimesRelay.accept(result.busTimes)
                isLoadingRelay.accept(false) // Hide indicator and show scroll view
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
        let countdownViewModel = CountdownViewModel(dependency: CountdownViewModel.Dependency(destination: .college, countupRelay: countupRelay, busTimesDriver: busTimesDriver))
        let busListViewModel = BusListViewModel(dependency: BusListViewModel.Dependency(destination: .college, busTimesDriver: busTimesDriver))
        
        return Output(children: Children(diagramViewModel: diagramViewModel,
                                         countdownViewModel: countdownViewModel,
                                         busListViewModel: busListViewModel),
                      isLoadingDriver: isLoadingRelay.asDriver(),
                      presentSettingSignal: input.settingBarButtonDidTap)
    }
}

