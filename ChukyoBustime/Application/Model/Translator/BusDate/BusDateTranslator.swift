//
//  BusDateTranslator.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra

struct BusDateTranslator: Translator {
    typealias Input = BusDateEntity
    typealias Output = BusDate
    
    func translate(_ input: BusDateEntity) throws -> BusDate {
        return BusDate(diagram: input.diagram,
                       diagramName: input.diagramName)
    }
}
