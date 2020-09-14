//
//  Stubs.swift
//  ChukyoBustimeTests
//
//  Created by 山田隼也 on 2020/09/14.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
@testable import ChukyoBustime

enum Stubs {
    enum BusTimes {
        static let empty: [BusTime] = []
        static let single: [BusTime] = [
            BusTime(hour: 8, minute: 0, second: 28800, arrivalHour: 8, arrivalMinute: 10, arrivalSecond: 29400, isReturn: false, isLast: false, isKaizu: false)
        ]
        static let array: [BusTime] = [
            BusTime(hour: 8, minute: 0, second: 28800, arrivalHour: 8, arrivalMinute: 10, arrivalSecond: 29400, isReturn: false, isLast: false, isKaizu: false),
            BusTime(hour: 8, minute: 15, second: 29700, arrivalHour: 8, arrivalMinute: 25, arrivalSecond: 30300, isReturn: false, isLast: false, isKaizu: false),
            BusTime(hour: 8, minute: 30, second: 30600, arrivalHour: 8, arrivalMinute: 40, arrivalSecond: 31200, isReturn: false, isLast: false, isKaizu: false)
        ]
        static let isReturn: [BusTime] = [
            BusTime(hour: 8, minute: 0, second: 28800, arrivalHour: 8, arrivalMinute: 10, arrivalSecond: 29400, isReturn: true, isLast: false, isKaizu: false)
        ]
        static let isLast: [BusTime] = [
            BusTime(hour: 8, minute: 0, second: 28800, arrivalHour: 8, arrivalMinute: 10, arrivalSecond: 29400, isReturn: false, isLast: true, isKaizu: false)
        ]
        static let isKaizu: [BusTime] = [
            BusTime(hour: 8, minute: 0, second: 28800, arrivalHour: 8, arrivalMinute: 10, arrivalSecond: 29400, isReturn: false, isLast: false, isKaizu: true)
        ]
    }
}
