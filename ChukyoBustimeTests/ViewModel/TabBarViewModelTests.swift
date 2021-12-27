//
//  TabBarViewModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/04.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import ChukyoBustime

class TabBarViewModelTests: XCTestCase {

    func test_指定したタブのインデックスが流れることを確認() {
        let index = TabBarItem.toCollege
        let model = MockTabBarModelImpl(initialTab: index)
        let viewModel = TabBarViewModel(model: model)
        
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(Int.self)
        let disposeBag = DisposeBag()
        
        scheduler.scheduleAt(100) {
            viewModel.output.selectedTab
                .drive(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(100, index.rawValue)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
}
