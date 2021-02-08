//
//  RootViewModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/02/08.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import ChukyoBustime

class RootViewModelTests: XCTestCase {

    func test_画面表示時にタブの画面へ切り替わるイベントが流れることを確認() {
        let viewModel = RootViewModel(model: MockRootModelImpl())
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(Bool.self)
        
        scheduler.scheduleAt(100) {
            // NOTE: Void のイベントは比較できないので、`map` で `Bool` に変換して比較を行う
            viewModel.output.replaceRootToTabBar
                .map { return true }
                .emit(to: testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            viewModel.input.viewDidLoad()
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(200, true)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
}
