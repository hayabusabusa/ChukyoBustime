//
//  DateService.swift
//  
//
//  Created by Shunya Yamada on 2022/11/05.
//

import Foundation
import SwiftDate

public protocol DateServiceProtocol {
    /// 現在の時刻を 00:00 から経過した秒数に直したもの.
    var nowTimeForSecond: Int { get }

    /// ロケールに応じた現在の日付を返す.
    var nowDate: Date { get }

    /// 指定された日付が今日の日付かどうかを返す.
    /// - Parameter date: 任意の日付.
    /// - Returns: 今日の日付かどうか.
    func isToday(_ date: Date) -> Bool

    /// 現在の年月日で、時間と分を指定した日付を返す.
    /// - Parameters:
    ///   - hour: 時間.
    ///   - minute: 分.
    /// - Returns: 時間と分を指定した `Date`.
    func today(hour: Int, minute: Int) -> Date

    /// 指定された日付をフォーマットした文字列にして返す.
    /// - Parameters:
    ///   - date: 任意の日付.
    ///   - format: 任意のフォーマット.
    /// - Returns: 日付をフォーマットした文字列.
    func formatted(_ date: Date, format: String) -> String
}

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
