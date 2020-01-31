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
    
    // MARK: I/O
    
    struct Input {
        
    }
    
    struct Output {
        let diagramDriver: Driver<String>
    }
    
    // MARK: Transform I/O
    
    func transform(input: ToStationViewModel.Input) -> ToStationViewModel.Output {
        let diagramRelay: BehaviorRelay<String> = .init(value: "")
        
        model.getBusDate(at: Date())
            .subscribe(onSuccess: { busDate in
                diagramRelay.accept(busDate.diagramName)
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
        
        return Output(diagramDriver: diagramRelay.asDriver())
    }
}
