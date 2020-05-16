//
//  BusListViewModel.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class BusListViewModel {
    
    // MARK: Dependency
    
    typealias Dependency = (destination: Destination, busTimesDriver: Driver<[BusTime]>)
    
    let dependency: Dependency
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
}

extension BusListViewModel: ViewModelType {
    
    // MARK: I/O
    
    struct Input {
        let busListDidTap: Signal<Void>
    }
    
    struct Output {
        let busListDriver: Driver<(first: BusTime?, second: BusTime?, third: BusTime?)>
        let messageSignal: Signal<String>
    }
    
    // MARK: Transform I/O
    
    func transform(input: BusListViewModel.Input) -> BusListViewModel.Output {
        let busListRelay: BehaviorRelay<(first: BusTime?, second: BusTime?, third: BusTime?)> = .init(value: (first: nil, second: nil, third: nil))
        let messageRelay: PublishRelay<String> = .init()
        
        dependency.busTimesDriver
            .translate(with: BusListViewableTranslator())
            .drive(busListRelay)
            .disposed(by: disposeBag)
        
        input.busListDidTap
            .emit(onNext: {
                messageRelay.accept("バスがくる5分前に\n通知が来るように設定できます。\nまずは通知の表示を許可してください。")
            })
            .disposed(by: disposeBag)
        
        return Output(busListDriver: busListRelay.asDriver(),
                      messageSignal: messageRelay.asSignal())
    }
}
