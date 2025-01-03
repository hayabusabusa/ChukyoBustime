//
//  Date+.swift
//  Package
//
//  Created by Shunya Yamada on 2025/01/03.
//

import Foundation
import SwiftDate

extension Date {
    /// テスト時に利用する `Date` の値.
    ///
    /// - note: `Date(timeIntervalSince1970: 1735700400)` だと `Region` によってはずれてしまうため
    /// `DateInRegion` で `Date` を作成する.
    static var testValue: Date {
        DateInRegion(
            year: 2025,
            month: 1,
            day: 1,
            hour: 12,
            minute: 0,
            region: .current
        ).date
    }
}
