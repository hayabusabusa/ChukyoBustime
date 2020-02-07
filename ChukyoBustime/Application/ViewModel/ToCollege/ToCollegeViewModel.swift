//
//  ToCollegeViewModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/02/06.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
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
        let settingBarButtonDidTap: Signal<Void>
    }
    
    struct Output {
        let children: Children
        let presentSetting: Driver<Void>
    }
    
    // MARK: Transform I/O
    
    func transform(input: ToCollegeViewModel.Input) -> ToCollegeViewModel.Output {
        let diagramRelay: BehaviorRelay<String> = .init(value: "")
        let busTimesRelay: BehaviorRelay<[BusTime]> = .init(value: [])
        
        let now = Date()
        model.getBusTimes(at: now)
            .subscribe(onSuccess: { result in
                diagramRelay.accept(result.busDate.diagramName)
                busTimesRelay.accept(result.busTimes)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        let diagramDriver: Driver<String> = diagramRelay.asDriver()
        let busTimesDriver: Driver<[BusTime]> = busTimesRelay.asDriver()
        let diagramViewModel = DiagramViewModel(dependency: diagramDriver)
        let countdownViewModel = CountdownViewModel(dependency: CountdownViewModel.Dependency(destination: .college, busTimesDriver: busTimesDriver))
        let busListViewModel = BusListViewModel(dependency: BusListViewModel.Dependency(destination: .college, busTimesDriver: busTimesDriver))
        
        return Output(children: Children(diagramViewModel: diagramViewModel,
                                         countdownViewModel: countdownViewModel,
                                         busListViewModel: busListViewModel),
                      presentSetting: input.settingBarButtonDidTap.asDriver(onErrorDriveWith: .empty()))
    }
}

