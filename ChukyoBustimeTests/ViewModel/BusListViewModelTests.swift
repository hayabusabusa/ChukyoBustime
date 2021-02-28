//
//  BusListViewModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/02/26.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
import SwiftDate
@testable import ChukyoBustime

class BusListViewModelTests: XCTestCase {
    
    func test_バス一覧が流れることを確認() {
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(Int.self)
        let disposeBag = DisposeBag()
        
        let now = DateInRegion(Date(), region: .current)
        let second = now.hour * 3600 + now.minute * 60 + now.second
        let busTimes = scheduler.createHotObservable([
            .next(100,
                  [
                    BusTime(hour: now.hour, minute: now.minute, second: second + 1, arrivalHour: now.hour + 2, arrivalMinute: now.minute + 2, arrivalSecond: second + 2, isReturn: true, isLast: true, isKaizu: true),
                    BusTime(hour: now.hour, minute: now.minute, second: second + 2, arrivalHour: now.hour + 3, arrivalMinute: now.minute + 3, arrivalSecond: second + 3, isReturn: true, isLast: true, isKaizu: true)
                  ]
            )
        ])
        .asDriver(onErrorDriveWith: .empty())
        
        let model = MockBusListModelImpl()
        let dependency = BusListViewModel.Dependency(destination: .station, busTimesDriver: busTimes, model: model)
        let viewModel = BusListViewModel(dependency: dependency)
        
        // MOTE: `nil` のものを除去して、結果として流れる件数のみ比較する
        viewModel.output.busList
            .map { Mirror(reflecting: $0).children.map { $0.value as? BusTime } }
            .map { $0.compactMap { $0 }.count }
            .drive(testableObserver)
            .disposed(by: disposeBag)
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(0, 0),
            .next(100, 2)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_アラートのOKアクションを押した際にイベントが流れることを確認() {
        let scheduler = TestScheduler(initialClock: 0)
        let disposeBag = DisposeBag()
        
        let now = DateInRegion(Date(), region: .current)
        let second = now.hour * 3600 + now.minute * 60 + now.second
        let busTimes = scheduler.createHotObservable([
            .next(100,
                  [
                    BusTime(hour: now.hour, minute: now.minute, second: second + 1, arrivalHour: now.hour + 2, arrivalMinute: now.minute + 2, arrivalSecond: second + 2, isReturn: true, isLast: true, isKaizu: true)
                  ]
            )
        ])
        .asDriver(onErrorDriveWith: .empty())
        
        // NOTE: 6分後のデータを用意
        let busTime = BusTime(hour: now.hour, minute: now.minute + 6, second: second + 360, arrivalHour: now.hour, arrivalMinute: now.minute + 6, arrivalSecond: second + 360, isReturn: true, isLast: true, isKaizu: true)
        
        XCTContext.runActivity(named: "通知が許可済みの場合はメッセージが表示されることを確認") { _ in
            let message = String(format: "%02i:%02i の5分前に\n通知が来るように設定しました。", busTime.hour, busTime.minute)
            let testableObserver = scheduler.createObserver(String.self)
            
            let model = MockBusListModelImpl()
            let dependency = BusListViewModel.Dependency(destination: .station, busTimesDriver: busTimes, model: model)
            let viewModel = BusListViewModel(dependency: dependency)
            
            viewModel.output.message
                .emit(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                viewModel.input.confirmAlertOKTapped(busTime: busTime)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, message)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
        
        XCTContext.runActivity(named: "通知が許可されていない場合は特定のメッセージが表示されることを確認") { _ in
            let message = "バスがくる5分前に\n通知が来るように設定できます。\nまずは通知の表示を許可してください。"
            let testableObserver = scheduler.createObserver(String.self)
            
            let model = MockBusListModelImpl(isAuthorized: false)
            let dependency = BusListViewModel.Dependency(destination: .station, busTimesDriver: busTimes, model: model)
            let viewModel = BusListViewModel(dependency: dependency)
            
            viewModel.output.message.debug()
                .emit(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                viewModel.input.confirmAlertOKTapped(busTime: busTime)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, message)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
    }
}
