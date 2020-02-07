//
//  CountdownViewModel.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import SwiftDate
import RxSwift
import RxCocoa

final class CountdownViewModel {
    
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

extension CountdownViewModel: ViewModelType {
    
    // MARK: I/O
    
    struct Input {
        
    }
    
    struct Output {
        let timerDriver: Driver<String>
    }
    
    // MARK: Transform I/O
    
    func transform(input: CountdownViewModel.Input) -> CountdownViewModel.Output {
        let isValidRelay: BehaviorRelay<Bool> = .init(value: false)
        let timerRelay: BehaviorRelay<Int> = .init(value: 0)
        
        dependency.busTimesDriver
            .drive(onNext: { busTimes in
                if let first = busTimes.first {
                    let now = DateInRegion(Date(), region: .current)
                    let interval = first.second - (now.hour * 3600 + now.minute * 60 + now.second)
                    isValidRelay.accept(true)
                    timerRelay.accept(Int(interval))
                }
            })
            .disposed(by: disposeBag)
        
        isValidRelay
            .distinctUntilChanged()
            .flatMapLatest { $0 ? Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) : Observable.empty() }
            .share(replay: 1, scope: .forever)
            .subscribe(onNext: { _ in
                if timerRelay.value <= 0 {
                    isValidRelay.accept(false)
                } else {
                    timerRelay.accept(timerRelay.value - 1)
                }
            })
            .disposed(by: disposeBag)
        
        let timerDriver = timerRelay
            .map { String(format: "%02i:%02i", $0 / 60 % 60, $0 % 60) }
            .asDriver(onErrorDriveWith: .empty())
        return Output(timerDriver: timerDriver)
    }
}
