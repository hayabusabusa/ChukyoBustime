//
//  BusTimeEntity.swift
//  Infra
//
//  Created by 山田隼也 on 2020/01/28.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RealmSwift

public final class BusTimeEntity: Object, Decodable {
    @objc public dynamic var hour: Int = 0
    @objc public dynamic var minute: Int = 0
    @objc public dynamic var second: Int = 0
    @objc public dynamic var arrivalHour: Int = 0
    @objc public dynamic var arrivalMinute: Int = 0
    @objc public dynamic var arrivalSecond: Int = 0
    @objc public dynamic var isReturn: Bool = false
    @objc public dynamic var isLast: Bool = false
    @objc public dynamic var isKaizu: Bool = false
    
    private enum CodingKeys: String, CodingKey {
        case hour
        case minute
        case second
        case arrivalHour
        case arrivalMinute
        case arrivalSecond
        case isReturn
        case isLast
        case isKaizu
    }
    
    public convenience init(hour: Int,
                            minute: Int,
                            second: Int,
                            arrivalHour: Int,
                            arrivalMinute: Int,
                            arrivalSecond: Int,
                            isReturn: Bool,
                            isLast: Bool,
                            isKaizu: Bool) {
        self.init()
        self.hour = hour
        self.minute = minute
        self.second = second
        self.arrivalHour = arrivalHour
        self.arrivalMinute = arrivalMinute
        self.arrivalSecond = arrivalSecond
        self.isReturn = isReturn
        self.isLast = isLast
        self.isKaizu = isKaizu
    }
}
