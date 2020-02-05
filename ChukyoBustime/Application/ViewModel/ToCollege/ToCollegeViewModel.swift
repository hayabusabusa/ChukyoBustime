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
    
    // MARK: I/O
    
    struct Input {
        
    }
    
    struct Output {
        let diagramDriver: Driver<String>
        let busTimesDriver: Driver<[BusTime]>
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
        
        return Output(diagramDriver: diagramRelay.asDriver(),
                      busTimesDriver: busTimesRelay.asDriver())
    }
}

