//
//  ToCollegeViewModelTests.swift
//  ChukyoBustimeTests
//
//  Created by 山田隼也 on 2020/09/14.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import XCTest
import RxCocoa
import RxSwift
import RxTest
@testable import ChukyoBustime

class ToCollegeViewModelTests: XCTestCase {
    
    // MARK: Properties
    
    private let foregroundRelay             = PublishRelay<Void>()
    private let calendarButtonDidTapRelay   = PublishRelay<Void>()
    private let timeTableButtonDidTapRelay  = PublishRelay<Void>()
    private let settingBarButtonDidTapRelay = PublishRelay<Void>()
    
    // MARK: Setup

    override func setUp() {
        super.setUp()
    }
    
    // MARK: Tests
    
    func test_Firestoreへのデータフェッチ完了後の動作を確認() {
        let input = ToCollegeViewModel.Input(foregroundSignal: foregroundRelay.asSignal(),
                                             calendarButtonDidTap: calendarButtonDidTapRelay.asSignal(),
                                             timeTableButtonDidTap: timeTableButtonDidTapRelay.asSignal(),
                                             settingBarButtonDidTap: settingBarButtonDidTapRelay.asSignal())
        
        XCTContext.runActivity(named: "データフェッチ完了後はインジケーターが表示されていないことを確認") { _ in
            let viewModel           = ToCollegeViewModel(model: MockToCollegeModelImpl(busTimes: Stubs.BusTimes.single))
            let output              = viewModel.transform(input: input)
            let scheduler           = TestScheduler(initialClock: 0)
            let disposeBag          = DisposeBag()
            let testableObserver    = scheduler.createObserver(StateView.State.self)
            
            scheduler.scheduleAt(100) {
                output.stateDriver
                    .drive(testableObserver)
                    .disposed(by: disposeBag)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, StateView.State.none)
            ])
            XCTAssertEqual(testableObserver.events, expression, "データフェッチ後は `State` が `none` になること")
        }
        
        XCTContext.runActivity(named: "空のデータフェッチ完了後は Empty State が表示されていることを確認") { _ in
            let viewModel           = ToCollegeViewModel(model: MockToCollegeModelImpl(busTimes: Stubs.BusTimes.empty))
            let output              = viewModel.transform(input: input)
            let scheduler           = TestScheduler(initialClock: 0)
            let disposeBag          = DisposeBag()
            let testableObserver    = scheduler.createObserver(StateView.State.self)
            
            scheduler.scheduleAt(100) {
                output.stateDriver
                    .drive(testableObserver)
                    .disposed(by: disposeBag)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, StateView.State.empty)
            ])
            XCTAssertEqual(testableObserver.events, expression, "空のデータフェッチ後は `State` が `empty` になること")
        }
    }
}
