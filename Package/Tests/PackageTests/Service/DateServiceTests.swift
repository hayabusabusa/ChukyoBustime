//
//  DateServiceTests.swift
//  
//
//  Created by Shunya Yamada on 2023/02/02.
//

import XCTest

@testable import Service

final class DateServiceTests: XCTestCase {
    func test_基本機能の確認() {
        let today = Date()
        let service = DateService()

        XCTContext.runActivity(named: "今日の日付かどうかの判定が正しく行えること") { _ in
            let past = Date(timeIntervalSince1970: 821372400)
            XCTAssertTrue(service.isToday(today))
            XCTAssertFalse(service.isToday(past))
        }

        XCTContext.runActivity(named: "任意の日付を任意のフォーマットに正しく変換できること") { _ in
            let date = Date(timeIntervalSince1970: 821372400)
            XCTAssertEqual(service.formatted(date, format: "yyyy-MM-dd"), "1996-01-12")
        }
    }
}
