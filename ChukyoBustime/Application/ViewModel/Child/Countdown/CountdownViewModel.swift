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

// MARK: - Protocols

protocol CountdownViewModelInputs {
    
}

protocol CountdownViewModelOutputs {
    var timer: Driver<String> { get }
    var arrivalTime: Driver<String?> { get }
    var departureTime: Driver<String?> { get }
    var isHideLastButton: Driver<Bool> { get }
    var isHideKaizuButton: Driver<Bool> { get }
    var isHideReturnButton: Driver<Bool> { get }
}

protocol CountdownViewModelType {
    var input: CountdownViewModelInputs { get }
    var output: CountdownViewModelOutputs { get }
}

// MARK: - ViewModel

final class CountdownViewModel: CountdownViewModelInputs, CountdownViewModelOutputs {
    
    // MARK: Dependency
    
    struct Dependency {
        let busTimes: Driver<[BusTime]>
        let destination: Destination
        let countupRelay: PublishRelay<Void>
    }
    let dependency: Dependency
    
    // MARK: Propreties
    
    private let disposeBag = DisposeBag()
    private let timerRelay: BehaviorRelay<Int>
    private let isValidRelay: BehaviorRelay<Bool>
    private let countupRelay: PublishRelay<Void>
    private let isHideLastButtonRelay: BehaviorRelay<Bool>
    private let isHideKaizuButtonRelay: BehaviorRelay<Bool>
    private let isHideReturnButtonRelay: BehaviorRelay<Bool>
    
    // MARK: Outputs
    
    let timer: Driver<String>
    let arrivalTime: Driver<String?>
    let departureTime: Driver<String?>
    let isHideLastButton: Driver<Bool>
    let isHideKaizuButton: Driver<Bool>
    let isHideReturnButton: Driver<Bool>
    
    // MARK: Initializer
    
    init(dependency: Dependency) {
        self.dependency = dependency
        self.timerRelay = .init(value: 0)
        self.isValidRelay = .init(value: false)
        self.countupRelay = dependency.countupRelay
        self.isHideLastButtonRelay = .init(value: true)
        self.isHideKaizuButtonRelay = .init(value: true)
        self.isHideReturnButtonRelay = .init(value: true)
        
        timer = timerRelay
            .map { $0 < 0 ? 0 : $0 } // NOTE: 負の数は 0 として流す.
            .map { $0 >= 21600 ? "60分以上" : String(format: "%02i:%02i", $0 / 60 % 60, $0 % 60) } // NOTE: 1時間以上なら 1時間以上 と表記する.
            .asDriver(onErrorDriveWith: .empty())
        arrivalTime = dependency.busTimes
            .map { busTimes in
                guard let busTime = busTimes.first else {
                    return nil
                }
                return String(format: "%i:%02i", busTime.arrivalHour, busTime.arrivalMinute)
            }
        departureTime = dependency.busTimes
            .map { busTimes in
                guard let busTime = busTimes.first else {
                    return nil
                }
                return String(format: "%i:%02i", busTime.hour, busTime.minute)
            }
        isHideLastButton = isHideLastButtonRelay.asDriver()
        isHideKaizuButton = isHideKaizuButtonRelay.asDriver()
        isHideReturnButton = isHideReturnButtonRelay.asDriver()
        
        // TODO: `drive` と `subscribe` をここでやらずに Model に閉じ込めたい
        dependency.busTimes
            .drive(onNext: { [weak self] busTimes in
                // NOTE: 次のバスがある時のみ
                if let busTime = busTimes.first {
                    let now = DateInRegion(Date(), region: .current)
                    let interval = busTime.second - (now.hour * 3600 + now.minute * 60 + now.second)
                    
                    self?.isValidRelay.accept(true)
                    self?.isHideLastButtonRelay.accept(!busTime.isLast)
                    self?.isHideReturnButtonRelay.accept(!busTime.isReturn)
                    self?.isHideKaizuButtonRelay.accept(!busTime.isKaizu)
                    self?.timerRelay.accept(Int(interval))
                }
            })
            .disposed(by: disposeBag)
        isValidRelay
            .distinctUntilChanged()
            .flatMapLatest { $0 ? Observable<Int>.interval(RxTimeInterval.seconds(1), scheduler: MainScheduler.instance) : Observable.empty() }
            .share(replay: 1, scope: .forever)
            .subscribe(onNext: { [weak self] _ in
                let timerValue = self?.timerRelay.value ?? 0
                if timerValue <= 0 {
                    self?.isValidRelay.accept(false)
                    self?.countupRelay.accept(())
                } else {
                    self?.timerRelay.accept(timerValue - 1)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension CountdownViewModel: CountdownViewModelType {
    var input: CountdownViewModelInputs { return self }
    var output: CountdownViewModelOutputs { return self }
}
