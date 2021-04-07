//
//  TabBarModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/04/07.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Infra
import RxSwift
import RxTest
import XCTest
@testable import ChukyoBustime

class TabBarModelTests: XCTestCase {
    
    private var storedTabSetting: TabBarItem?
    
    override func setUp() {
        super.setUp()
        
        // NOTE: 元々保存されていたタブがあれば取り出す
        storedTabSetting = UserDefaultsProvider.shared.enumObject(type: TabBarItem.self, forKey: .initialTab)
    }

    override func tearDown() {
        super.tearDown()
        
        // NOTE: 元々保存されていたタブがあれば元に戻す
        guard let storedTabSetting = storedTabSetting else {
            return
        }
        UserDefaultsProvider.shared.setEnum(value: storedTabSetting, forKey: .initialTab)
    }
 
    func test_初期化時に保存されたタブの設定が流れることを確認() {
        let disposeBag = DisposeBag()
        
        XCTContext.runActivity(named: "タブの設定保存されていた場合は保存されていたものがsubscribe時に流れること") { _ in
            // NOTE: 元々保存されていない場合はデフォルトで流れる浄水駅行きのタブになる
            let initialTab = storedTabSetting ?? .toStation
            let model = TabBarModelImpl()
            
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(Int.self)
            
            scheduler.scheduleAt(100) {
                model.initialTabStream
                    .map { $0.rawValue }
                    .bind(to: testableObserver)
                    .disposed(by: disposeBag)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, initialTab.rawValue)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
        
        XCTContext.runActivity(named: "タブの設定保存されていない場合はデフォルトで浄水駅行きのタブがsubscribe時に流れること") { _ in
            // NOTE: タブの設定を削除する
            removeTabSetting()
            
            let initialTab = TabBarItem.toStation
            let model = TabBarModelImpl()
            
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(Int.self)
            
            scheduler.scheduleAt(100) {
                model.initialTabStream
                    .map { $0.rawValue }
                    .bind(to: testableObserver)
                    .disposed(by: disposeBag)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, initialTab.rawValue)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
    }
}

// MARK: - Private method

extension TabBarModelTests {
    
    private func removeTabSetting() {
        UserDefaultsProvider.shared.removeObject(forKey: .initialTab)
    }
}
