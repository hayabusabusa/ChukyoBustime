//
//  BusListModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/14.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import ChukyoBustime

class BusListModelTests: XCTestCase {

    func test_ローカル通知設定時に正しいイベントが流れることを確認() {
        let busTime = Mock.createBusTime()
        let disposeBag = DisposeBag()
        
        XCTContext.runActivity(named: "設定完了後に完了のメッセージが流れること") { _ in
            let repository = MockUserNotificationRepositoryImpl()
            let model = BusListModelImpl(userNotificationRepository: repository)
            
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(String.self)
            
            model.messageStream
                .bind(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                model.setNotification(at: busTime)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, String(format: "%02i:%02i の5分前に\n通知が来るように設定しました。", busTime.hour, busTime.minute))
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
        
        XCTContext.runActivity(named: "エラー時にはエラーメッセージが流れること") { _ in
            let repository = MockUserNotificationRepositoryImpl(isErrorOccured: true)
            let model = BusListModelImpl(userNotificationRepository: repository)
            
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(String.self)
            
            model.errorStream
                .bind(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                model.setNotification(at: busTime)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, MockError.somethingWentWrong.description)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
    }
}
