//
//  ToStationViewModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/06.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import ChukyoBustime

class ToStationViewModelTests: XCTestCase {
    
    func test_正常系の動作でStateの変化が正しいことを確認() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(StateView.State.self)
        
        let busDate = Mock.busDate
        let busTimes = Mock.createBusTimes(count: 1, interval: 1)
        let model = MockToStationModelImpl(busDate: busDate, busTimes: busTimes)
        let viewModel = ToStationViewModel(model: model)
        
        scheduler.scheduleAt(100) {
            viewModel.output.state
                .drive(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            viewModel.input.viewDidLoad()
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(100, StateView.State.loading),
            .next(200, StateView.State.none)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_異常系の動作でStateの変化が正しいことを確認() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(StateView.State.self)
        
        let busDate = Mock.busDate
        let busTimes = Mock.createBusTimes(count: 1, interval: 1)
        let model = MockToStationModelImpl(busDate: busDate, busTimes: busTimes, isErrorOccured: true)
        let viewModel = ToStationViewModel(model: model)
        
        scheduler.scheduleAt(100) {
            viewModel.output.state
                .drive(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            viewModel.input.viewDidLoad()
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(100, StateView.State.loading),
            .next(200, StateView.State.error)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    // NOTE: 実際に待つ時間が発生するので一旦テストとしては無視する
    func _test_最終バス運行後のStateが正しいことを確認() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(StateView.State.self)
        
        let busDate = Mock.busDate
        let busTimes = Mock.createBusTimes(count: 1, interval: 1)
        let model = MockToStationModelImpl(busDate: busDate, busTimes: busTimes)
        let viewModel = ToStationViewModel(model: model)
        
        scheduler.scheduleAt(100) {
            viewModel.output.state
                .drive(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            viewModel.input.viewDidLoad()
        }
        
        // NOTE: 仮想時間を更新
        scheduler.scheduleAt(300, action: {})
        
        scheduler.start()
        
        // NOTE: 完了まで待つ... この処理なしで確認できるようにリファクタしたい
        let expectation = XCTestExpectation(description: "Wait for timer count up")
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3.0)
        
        let expression = Recorded.events([
            .next(100, StateView.State.loading),
            .next(200, StateView.State.none),
            .next(300, StateView.State.empty)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
}
