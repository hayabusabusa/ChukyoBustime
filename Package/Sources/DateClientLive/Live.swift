//
//  Live.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/12.
//

import DateClient
import Dependencies
import Foundation
import SwiftDate

extension DateClient: DependencyKey {
    public static var liveValue: DateClient {
        .init {
            DateInRegion(Date(), region: .current).date
        } nowTimeForSeconds: {
            let now = DateInRegion(Date(), region: .current)
            return now.hour * 3600 + now.minute * 60 + now.second
        } today: { hour, minute in
            let now = DateInRegion(Date(), region: .current)
            let adjustedDateInRegion = DateInRegion(
                year: now.year,
                month: now.month,
                day: now.day,
                hour: hour,
                minute: minute
            )
            return adjustedDateInRegion.date
        } formatted: { date, format in
            let dateInRegion = DateInRegion(date, region: .current)
            return dateInRegion.toFormat(format)
        }
    }
}
