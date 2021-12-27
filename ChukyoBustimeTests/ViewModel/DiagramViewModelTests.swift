//
//  DiagramViewModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/02/11.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import XCTest
import RxSwift
import RxRelay
import RxTest
@testable import ChukyoBustime

class DiagramViewModelTests: XCTestCase {

    func test_初期化時にダイヤ名が流れていることを確認() {
        let diagramNameDriver = BehaviorRelay<String>(value: "テスト").asDriver(onErrorDriveWith: .empty())
        let dependency = DiagramViewModel.Dependency(diagramNameDriver: diagramNameDriver)
        let viewModel = DiagramViewModel(dependency: dependency)
        let disposeBag = DisposeBag()
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(String.self)
        
        scheduler.scheduleAt(100) {
            viewModel.output.diagramName
                .drive(testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(100, "テスト")
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
}
