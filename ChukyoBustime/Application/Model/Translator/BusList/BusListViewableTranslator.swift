//
//  BusListViewableTranslator.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/01/31.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

struct BusListViewableTranslator: ViewableTranslator {
    typealias Input = [BusTime]
    typealias Output = (first: BusTime?, second: BusTime?, third: BusTime?)
    
    func translate(_ input: [BusTime]) -> (first: BusTime?, second: BusTime?, third: BusTime?) {
        let first = input.enumerated().first(where: { $0.offset == 0 })?.element
        let second = input.enumerated().first(where: { $0.offset == 1 })?.element
        let third = input.enumerated().first(where: { $0.offset == 2 })?.element
        return (first: first, second: second, third: third)
    }
}
