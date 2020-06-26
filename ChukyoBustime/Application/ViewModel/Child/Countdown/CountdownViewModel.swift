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
    
    typealias Dependency = (destination: Destination, countupRelay: PublishRelay<Void>, busTimesDriver: Driver<[BusTime]>)
    
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
        let isHideLastButtonDriver: Driver<Bool>
        let isHideReturnButtonDriver: Driver<Bool>
        let isHideKaizuButtonDriver: Driver<Bool>
        let timerDriver: Driver<String>
        let departureTimeDriver: Driver<String>
        let arrivalTimeDriver: Driver<String>
    }
    
    // MARK: Transform I/O
    
    func transform(input: CountdownViewModel.Input) -> CountdownViewModel.Output {
        let isValidRelay: BehaviorRelay<Bool> = .init(value: false)
        let isHideLastButtonRelay: BehaviorRelay<Bool> = .init(value: true)
        let isHideReturnButtonRelay: BehaviorRelay<Bool> = .init(value: true)
        let isHideKaizuButtonRelay: BehaviorRelay<Bool> = .init(value: true)
        let countupRelay: PublishRelay<Void> = dependency.countupRelay
        let timerRelay: BehaviorRelay<Int> = .init(value: 0)
        
        dependency.busTimesDriver
            .drive(onNext: { busTimes in
                if let first = busTimes.first {
                    let now = DateInRegion(Date(), region: .current)
                    let interval = first.second - (now.hour * 3600 + now.minute * 60 + now.second)
                    isValidRelay.accept(true)
                    isHideLastButtonRelay.accept(!first.isLast)
                    isHideReturnButtonRelay.accept(!first.isReturn)
                    isHideKaizuButtonRelay.accept(!first.isKaizu)
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
                    countupRelay.accept(())
                } else {
                    timerRelay.accept(timerRelay.value - 1)
                }
            })
            .disposed(by: disposeBag)
        
        let timerDriver = timerRelay
            .map { $0 < 0 ? 0 : $0 } // NOTE: 負の数は 0 として流す.
            .map { $0 >= 21600 ? "60分以上" : String(format: "%02i:%02i", $0 / 60 % 60, $0 % 60) } // NOTE: 1時間以上なら 1時間以上 と表記する.
            .asDriver(onErrorDriveWith: .empty())
        let departureTimeDriver: Driver<String> = dependency.busTimesDriver
            .map { busTimes in
                guard let first = busTimes.first else { return " " }
                return String(format: "%i:%02i", first.hour, first.minute)
            }
        let arrivalTimeDriver: Driver<String> = dependency.busTimesDriver
            .map { busTimes in
                guard let first = busTimes.first else { return " " }
                return String(format: "%i:%02i", first.arrivalHour, first.arrivalMinute)
            }
        return Output(isHideLastButtonDriver: isHideLastButtonRelay.asDriver(),
                      isHideReturnButtonDriver: isHideReturnButtonRelay.asDriver(),
                      isHideKaizuButtonDriver: isHideKaizuButtonRelay.asDriver(),
                      timerDriver: timerDriver,
                      departureTimeDriver: departureTimeDriver,
                      arrivalTimeDriver: arrivalTimeDriver)
    }
}
