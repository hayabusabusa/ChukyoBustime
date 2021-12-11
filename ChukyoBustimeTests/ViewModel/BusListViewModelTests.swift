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
        
        let busTimes = scheduler.createHotObservable([
            .next(100, Stub.createBusTimes(count: 2, interval: 1))
        ])
        .asDriver(onErrorDriveWith: .empty())
        
        let model = MockBusListModelImpl()
        let dependency = BusListViewModel.Dependency(destination: .station, busTimes: busTimes, model: model)
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
        
        let busTimes = scheduler.createHotObservable([
            .next(100, Stub.createBusTimes(count: 1))
        ])
        .asDriver(onErrorDriveWith: .empty())
        
        // NOTE: 6分後のデータを用意
        let busTimeAfterSixMinutes = Stub.createBusTime(interval: 360)
        
        XCTContext.runActivity(named: "通知が許可済みの場合はメッセージが表示されることを確認") { _ in
            let message = String(format: "%02i:%02i の5分前に\n通知が来るように設定しました。", busTimeAfterSixMinutes.hour, busTimeAfterSixMinutes.minute)
            let testableObserver = scheduler.createObserver(String.self)
            
            let model = MockBusListModelImpl()
            let dependency = BusListViewModel.Dependency(destination: .station, busTimes: busTimes, model: model)
            let viewModel = BusListViewModel(dependency: dependency)
            
            viewModel.output.message
                .emit(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                viewModel.input.confirmAlertOKTapped(busTime: busTimeAfterSixMinutes)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, message)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
        
        XCTContext.runActivity(named: "通知が許可されていない場合はエラーが流れることを確認") { _ in
            let message = MockError.somethingWentWrong.description
            let testableObserver = scheduler.createObserver(String.self)
            
            let model = MockBusListModelImpl(isAuthorized: false)
            let dependency = BusListViewModel.Dependency(destination: .station, busTimes: busTimes, model: model)
            let viewModel = BusListViewModel(dependency: dependency)
            
            viewModel.output.error
                .emit(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                viewModel.input.confirmAlertOKTapped(busTime: busTimeAfterSixMinutes)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, message)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
    }
}
