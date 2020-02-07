//
//  ToStationViewModel.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
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
        
    }
    
    struct Output {
        let children: Children
    }
    
    // MARK: Transform I/O
    
    func transform(input: ToStationViewModel.Input) -> ToStationViewModel.Output {
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
        let countdownViewModel = CountdownViewModel(dependency: CountdownViewModel.Dependency(destination: .station, busTimesDriver: busTimesDriver))
        let busListViewModel = BusListViewModel(dependency: BusListViewModel.Dependency(destination: .station, busTimesDriver: busTimesDriver))
        
        return Output(children: Children(diagramViewModel: diagramViewModel,
                                         countdownViewModel: countdownViewModel,
                                         busListViewModel: busListViewModel))
    }
}
