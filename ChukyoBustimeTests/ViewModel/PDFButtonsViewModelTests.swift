//
//  PDFButtonsViewModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/02/24.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import ChukyoBustime

class PDFButtonsViewModelTests: XCTestCase {

    func test_カレンダーボタンを押した際にURLが流れてくることを確認() {
        let url = URL(string: Mock.pdfURL.calendar)!
        let model = MockPDFButtonsModelImpl()
        let viewModel = PdfButtonsViewModel(model: model)
        let disposeBag = DisposeBag()
        
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(URL.self)
        
        scheduler.scheduleAt(100) {
            viewModel.output.presentSafari
                .emit(to: testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            viewModel.input.calendarButtonTapped()
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(200, url)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
    
    func test_時刻表ボタンを押した際にURLが流れてくることを確認() {
        let url = URL(string: Mock.pdfURL.timeTable)!
        let model = MockPDFButtonsModelImpl()
        let viewModel = PdfButtonsViewModel(model: model)
        let disposeBag = DisposeBag()
        
        let scheduler = TestScheduler(initialClock: 0)
        let testableObserver = scheduler.createObserver(URL.self)
        
        scheduler.scheduleAt(100) {
            viewModel.output.presentSafari
                .emit(to: testableObserver)
                .disposed(by: disposeBag)
        }
        
        scheduler.scheduleAt(200) {
            viewModel.input.timeTableButtonTapped()
        }
        
        scheduler.start()
        
        let expression = Recorded.events([
            .next(200, url)
        ])
        XCTAssertEqual(testableObserver.events, expression)
    }
}
