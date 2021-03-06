//
//  Mock.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/06.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import Foundation
import SwiftDate
@testable import ChukyoBustime

enum Mock {
    static let pdfURL = PdfUrl(calendar: "http://example.com", timeTable: "http://example.org")
    
    static func createBusTime(isReturn: Bool = false, isLast: Bool = false, isKaizu: Bool = false, interval: Int = 1) -> BusTime {
        let now = Self.now()
        return BusTime(hour: now.dateInRegion.hour,
                       minute: now.dateInRegion.minute,
                       second: now.second + interval,
                       arrivalHour: now.dateInRegion.hour,
                       arrivalMinute: now.dateInRegion.minute,
                       arrivalSecond: now.second + interval,
                       isReturn: isReturn,
                       isLast: isLast,
                       isKaizu: isKaizu)
    }
    
    static func createBusTimes(count: Int, interval: Int = 1) -> [BusTime] {
        let now = Self.now()
        let array = (1 ... count)
            .map {
                BusTime(hour: now.dateInRegion.hour,
                        minute: now.dateInRegion.minute,
                        second: now.second + interval * $0,
                        arrivalHour: now.dateInRegion.hour,
                        arrivalMinute: now.dateInRegion.minute,
                        arrivalSecond: now.second,
                        isReturn: false,
                        isLast: false,
                        isKaizu: false)
            }
        return array
    }
    
    static private func now() -> (dateInRegion: DateInRegion, second: Int) {
        let nowDateInRegion = DateInRegion(Date(), region: .current)
        let second = nowDateInRegion.hour * 3600 + nowDateInRegion.minute * 60 + nowDateInRegion.second
        return (nowDateInRegion, second)
    }
}
