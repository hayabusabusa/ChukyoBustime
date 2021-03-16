//
//  RootModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/13.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import ChukyoBustime

class RootModelTests: XCTestCase {

    func test_RemoteConfigフェッチ後に完了のイベントが流れることを確認() {
        XCTContext.runActivity(named: "フェッチ成功時に完了のイベントが流れること") { _ in
            let provider = MockRemoteConfigProvider()
            let model = RootModelImpl(remoteConfigProvider: provider)
            
            let disposeBag = DisposeBag()
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(Bool.self)
            
            // NOTE: `Void` では比較できないので、`Bool` に変換して比較する
            model.isCompletedStream
                .map { return true }
                .bind(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                model.fetch()
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, true)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
        
        XCTContext.runActivity(named: "エラー発生時でも完了のイベントが流れること") { _ in
            let provider = MockRemoteConfigProvider(isErrorOccured: true)
            let model = RootModelImpl(remoteConfigProvider: provider)
            
            let disposeBag = DisposeBag()
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(Bool.self)
            
            // NOTE: `Void` では比較できないので、`Bool` に変換して比較する
            model.isCompletedStream
                .map { return true }
                .bind(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                model.fetch()
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, true)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
    }
}
