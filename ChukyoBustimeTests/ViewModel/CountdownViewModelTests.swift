//
//  CountdownViewModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/02/13.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import XCTest
import RxSwift
import RxRelay
import RxTest
import RxBlocking
import SwiftDate
@testable import ChukyoBustime

// NOTE: `countupRelay` によるカウントアップの動作は親 ViewModel 側のテストで動作確認する

class CountdownViewModelTests: XCTestCase {
    
    // TODO: タイマーのテストは外部からインターバルを指定できるようにしたいので
    // タイマーの処理をModelに閉じ込めてからテストを作成する

    func test_各種ラベルが表示されることを確認() {
        let busTime = Mock.createBusTime(isReturn: true, isLast: true, isKaizu: true)
        let busTimes = Observable.of([busTime]).asDriver(onErrorDriveWith: .empty())
        let countupRelay = PublishRelay<Void>()
        
        let dependency = CountdownViewModel.Dependency(busTimes: busTimes, destination: .station, countupRelay: countupRelay)
        let viewModel = CountdownViewModel(dependency: dependency)
        let disposeBag = DisposeBag()
        
        XCTContext.runActivity(named: "折り返し運行のラベルが表示されることを確認") { _ in
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(Bool.self)
            
            scheduler.scheduleAt(100) {
                viewModel.output.isHideReturnButton
                    .drive(testableObserver)
                    .disposed(by: disposeBag)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, false)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
        
        XCTContext.runActivity(named: "最終バスのラベルが表示されることを確認") { _ in
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(Bool.self)
            
            scheduler.scheduleAt(100) {
                viewModel.output.isHideLastButton
                    .drive(testableObserver)
                    .disposed(by: disposeBag)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, false)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
        
        XCTContext.runActivity(named: "貝津駅経由のラベルが表示されることを確認") { _ in
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(Bool.self)
            
            scheduler.scheduleAt(100) {
                viewModel.output.isHideReturnButton
                    .drive(testableObserver)
                    .disposed(by: disposeBag)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, false)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
    }
    
    func test_次のバスまでの時間が正しく表示されることを確認() {
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(String.self)
        let disposeBag = DisposeBag()
        
        // NOTE: 1秒先のデータを用意して `HotObserver` に流す
        let busTime = Mock.createBusTime()
        let busTimes = scheduler.createHotObservable([
            .next(100, [busTime])
        ])
        .asDriver(onErrorDriveWith: .empty())
        
        let countupRelay = PublishRelay<Void>()
        let dependency = CountdownViewModel.Dependency(busTimes: busTimes, destination: .station, countupRelay: countupRelay)
        let viewModel = CountdownViewModel(dependency: dependency)
        
        viewModel.output.timer
            .drive(testableObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(0, "00:00"),
            .next(100, "00:01")
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
}
