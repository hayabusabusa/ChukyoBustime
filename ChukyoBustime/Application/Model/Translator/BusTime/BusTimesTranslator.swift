//
//  BusTimesTranslator.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra

struct BusTimesTranslator: Translator {
    typealias Input = [BusTimeEntity]
    typealias Output = [BusTime]
    
    func translate(_ input: [BusTimeEntity]) throws -> [BusTime] {
        return input.map { BusTime(hour: $0.hour,
                                   minute: $0.minute,
                                   isReturn: $0.isReturn,
                                   isLast: $0.isLast) }
    }
}
