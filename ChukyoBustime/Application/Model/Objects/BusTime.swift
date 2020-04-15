//
//  BusTime.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

struct BusTime {
    let hour: Int
    let minute: Int
    let second: Int
    let arrivalHour: Int
    let arrivalMinute: Int
    let arrivalSecond: Int
    let isReturn: Bool
    let isLast: Bool
    let isKaizu: Bool
}
