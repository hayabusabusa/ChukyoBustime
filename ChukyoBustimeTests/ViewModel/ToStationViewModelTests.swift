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
        
        let busDate = Stub.busDate
        let busTimes = Stub.createBusTimes(count: 1, interval: 1)
        let model = MockToDestinationModelImpl(busDate: busDate, busTimes: busTimes)
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
            .next(200, StateView.State.loading),
            .next(200, StateView.State.none)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_異常系の動作でStateの変化が正しいことを確認() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(StateView.State.self)
        
        let busDate = Stub.busDate
        let busTimes = Stub.createBusTimes(count: 1, interval: 1)
        let model = MockToDestinationModelImpl(busDate: busDate, busTimes: busTimes, isErrorOccured: true)
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
            .next(200, StateView.State.loading),
            .next(200, StateView.State.error)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    // NOTE: 実際に待つ時間が発生するので一旦テストとしては無視する
    func _test_最終バス運行後のStateが正しいことを確認() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(StateView.State.self)
        
        let busDate = Stub.busDate
        let busTimes = Stub.createBusTimes(count: 1, interval: 1)
        let model = MockToDestinationModelImpl(busDate: busDate, busTimes: busTimes)
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
    
    func test_設定ボタンタップ時に遷移のイベントが流れることを確認() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(Bool.self)
        
        let busDate = Stub.busDate
        let busTimes = Stub.createBusTimes(count: 1, interval: 1)
        let model = MockToDestinationModelImpl(busDate: busDate, busTimes: busTimes)
        let viewModel = ToStationViewModel(model: model)
        
        viewModel.output.presentSetting
            .map { return true }
            .emit(to: testableObserver)
            .disposed(by: disposeBag)
        
        scheduler.scheduleAt(100) {
            viewModel.input.settingButtonTapped()
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(100, true)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_StateViewのボタンタップ時にWebへ遷移するイベントが流れることを確認() {
        let disposeBag = DisposeBag()
        
        
        let busDate = Stub.busDate
        let busTimes = Stub.createBusTimes(count: 1, interval: 1)
        let model = MockToDestinationModelImpl(busDate: busDate, busTimes: busTimes)
        let viewModel = ToStationViewModel(model: model)
        
        XCTContext.runActivity(named: "カレンダーボタンタップ時にはカレンダーのPDFを表示するイベントが流れること") { _ in
            let url = URL(string: Stub.pdfURL.calendar)!
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(URL.self)
            
            viewModel.output.presentSafari
                .emit(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                viewModel.input.calendarButtonTapped()
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, url)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
        
        XCTContext.runActivity(named: "時刻表ボタンタップ時にはカレンダーのPDFを表示するイベントが流れること") { _ in
            let url = URL(string: Stub.pdfURL.timeTable)!
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(URL.self)
            
            viewModel.output.presentSafari
                .emit(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                viewModel.input.timeTableButtonTapped()
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, url)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
    }
}
