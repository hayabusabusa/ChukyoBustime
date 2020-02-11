//
//  BusDateAndBusTimesTranslator.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra

struct BusDateAndBusTimesTranslator: Translator {
    typealias Input = (busDate: BusDateEntity, busTimes: [BusTimeEntity])
    typealias Output = (busDate: BusDate, busTimes: [BusTime])
    
    func translate(_ input: (busDate: BusDateEntity, busTimes: [BusTimeEntity])) throws -> (busDate: BusDate, busTimes: [BusTime]) {
        let busDate = BusDate(diagramName: input.busDate.diagramName)
        let busTimes = input.busTimes.map { BusTime(hour: $0.hour,
                                                    minute: $0.minute,
                                                    second: $0.second,
                                                    arrivalHour: $0.arrivalHour,
                                                    arrivalMinute: $0.arrivalMinute,
                                                    arrivalSecond: $0.arrivalSecond,
                                                    isReturn: $0.isReturn,
                                                    isLast: $0.isLast) }
        return (busDate: busDate, busTimes: busTimes)
    }
}
