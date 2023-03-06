//
//  DateService.swift
//  
//
//  Created by Shunya Yamada on 2022/11/05.
//

import Foundation
import ServiceProtocol
import SwiftDate

/// 日付の処理をまとめた Service.
public struct DateService: DateServiceProtocol {
    /// 現在の `Date` を `DateInRegion` にラップしたもの.
    private var now: DateInRegion {
        DateInRegion(Date(), region: .current)
    }

    public var nowTimeForSecond: Int {
        let now = self.now
        return now.hour * 3600 + now.minute * 60 + now.second
    }

    public var nowDate: Date {
        now.date
    }

    public func isToday(_ date: Date) -> Bool {
        let dateInRegion = DateInRegion(date, region: .current)
        return dateInRegion.isToday
    }

    public func today(hour: Int, minute: Int) -> Date {
        let now = self.now
        let dateInRegion = DateInRegion(year: now.year,
                                        month: now.month,
                                        day: now.day,
                                        hour: hour,
                                        minute: minute)
        return dateInRegion.date
    }

    public func formatted(_ date: Date, format: String) -> String {
        let dateInRegion = DateInRegion(date, region: .current)
        return dateInRegion.toFormat(format)
    }
}
