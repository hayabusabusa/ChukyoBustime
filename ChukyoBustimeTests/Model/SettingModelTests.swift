//
//  SettingModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/13.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import XCTest
import Infra
import RxSwift
import RxTest
@testable import ChukyoBustime

class SettingModelTests: XCTestCase {
    
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

    func test_設定画面に表示する項目が流れることを確認() {
        let model = SettingModelImpl()
        
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(Int.self)
        
        model.sectionsRelay
            .map { self.getNumberOfRows(of: $0) }
            .bind(to: testableObserver)
            .disposed(by: disposeBag)
        
        scheduler.scheduleAt(100) {
            model.getSettings()
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(0, 0),
            .next(100, 5)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_タブの設定を保存後に正しいイベントが流れることを確認() {
        let tabBarItem = TabBarItem.toCollege
        let model = SettingModelImpl()
        
        let disposeBag = DisposeBag()
        
        XCTContext.runActivity(named: "表示している項目が更新されること") { _ in
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(String?.self)
            
            model.sectionsRelay
                .map { self.getTabBarSettingTitle(from: $0) }
                .bind(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                model.saveTabSetting(tabBarItem: tabBarItem)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(0, nil),
                .next(100, tabBarItem.title)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
        
        XCTContext.runActivity(named: "メッセージが表示されること") { _ in
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(String.self)
            
            model.messageRelay
                .bind(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                model.saveTabSetting(tabBarItem: tabBarItem)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, "起動時に表示する画面を\n \(tabBarItem.title) の画面に設定しました。")
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
    }
}

// MARK: - Helper

extension SettingModelTests {
    
    private func getNumberOfRows(of sections: [SettingSectionType]) -> Int {
        return sections.flatMap { $0.rows }.count
    }
    
    private func getTabBarSettingTitle(from sections: [SettingSectionType]) -> String? {
        return sections
            .flatMap { $0.rows }
            .map { row -> String? in
                if case .tabSetting(let title) = row {
                    return title
                } else {
                    return nil
                }
            }
            .compactMap { $0 }
            .first
    }
}
