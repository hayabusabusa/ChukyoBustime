//
//  PDFButtonsModelTests.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/04/04.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import XCTest
import RxSwift
import RxTest
@testable import ChukyoBustime

class PDFButtonsModelTests: XCTestCase {

    func test_指定したPDFのURLが流れることを確認() {
        let pdfURLEntity = Mock.pdfURLEntity
        let disposeBag = DisposeBag()
        
        XCTContext.runActivity(named: "運行カレンダーPDFのURLが流れること") { _ in
            let url = URL(string: pdfURLEntity.calendar)!
            let provider = MockRemoteConfigProvider()
            let model = PDFButtonsModelImpl(remoteConfigProvider: provider)
            
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(URL.self)
            
            model.pdfURLStream
                .bind(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                model.getPDFURL(of: .calendar)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, url)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
        
        XCTContext.runActivity(named: "時刻表PDFのURLが流れること") { _ in
            let url = URL(string: pdfURLEntity.timeTable)!
            let provider = MockRemoteConfigProvider()
            let model = PDFButtonsModelImpl(remoteConfigProvider: provider)
            
            let scheduler = TestScheduler(initialClock: 0)
            let testableObserver = scheduler.createObserver(URL.self)
            
            model.pdfURLStream
                .bind(to: testableObserver)
                .disposed(by: disposeBag)
            
            scheduler.scheduleAt(100) {
                model.getPDFURL(of: .timeTable)
            }
            
            scheduler.start()
            
            let expression = Recorded.events([
                .next(100, url)
            ])
            XCTAssertEqual(testableObserver.events, expression)
        }
    }
}
