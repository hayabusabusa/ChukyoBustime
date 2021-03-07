//
//  SettingViewModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/07.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import ChukyoBustime

class SettingViewModelTests: XCTestCase {

    func test_起動時のタブの状態が正しく表示されることを確認() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(String?.self)
        
        let model = MockSettingModelImpl(tabSetting: .toCollege)
        let viewModel = SettingViewModel(model: model)
        
        viewModel.output.sections
            .map { self.getTabBarSettingTitle(from: $0) }
            .drive(testableObserver)
            .disposed(by: disposeBag)
        
        scheduler.scheduleAt(100) {
            viewModel.input.viewDidLoad()
        }
        
        scheduler.start()
        
        let expression: [Recorded<Event<String?>>] = Recorded.events([
            .next(0, nil),
            .next(100, "大学行き")
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_セルタップ時に各イベントが正しく流れることを確認() {
        let disposeBag = DisposeBag()
        
        let model = MockSettingModelImpl(tabSetting: .toCollege)
        let viewModel = SettingViewModel(model: model)
        
        XCTContext.runActivity(named: "アプリについてのセルをタップした場合はURLを開くイベントが流れること") { _ in
            let url = Configurations.kAboutThisAppURL
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(URL.self)
            
            viewModel.output.presentSafari
                .emit(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                viewModel.input.didSelectRow(of: .app)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, url)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
        
        XCTContext.runActivity(named: "注意事項のセルをタップした場合はURLを開くイベントが流れること") { _ in
            let url = Configurations.kPrecautionsURL
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(URL.self)
            
            viewModel.output.presentSafari
                .emit(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                viewModel.input.didSelectRow(of: .precations)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, url)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
        
        XCTContext.runActivity(named: "プライバシーポリシーをタップした場合はURLを開くイベントが流れること") { _ in
            let url = Configurations.kPrivacyPolicyURL
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(URL.self)
            
            viewModel.output.presentSafari
                .emit(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                viewModel.input.didSelectRow(of: .privacyPolicy)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, url)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
        
        XCTContext.runActivity(named: "タブ設定のセルをタップした場合は設定が更新されること") { _ in
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(String?.self)
            
            viewModel.output.sections
                .map { self.getTabBarSettingTitle(from: $0) }
                .drive(testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                viewModel.input.viewDidLoad()
            }
            
            scheduler.scheduleAt(200) {
                viewModel.input.didSelectRow(of: .tabSetting(setting: "TEST"))
            }
            
            scheduler.start()
            
            let expression: [Recorded<Event<String?>>] = Recorded.events([
                .next(0, nil),
                .next(100, "大学行き"),
                .next(200, "浄水駅行き")
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
    }
    
    func test_閉じるボタンタップ時には設定画面を閉じるイベントが流れることを確認() {
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(Bool.self)
        
        let model = MockSettingModelImpl(tabSetting: .toCollege)
        let viewModel = SettingViewModel(model: model)
        
        viewModel.output.dismiss
            .map { return true }
            .emit(to: testableObserver)
            .disposed(by: disposeBag)
        
        scheduler.scheduleAt(100) {
            viewModel.input.closeButtonTapped()
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(100, true)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
}

// MARK: - Helper methods

extension SettingViewModelTests {
    
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
