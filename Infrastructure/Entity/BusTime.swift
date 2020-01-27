//
//  BusTime.swift
//  Infrastructure
//
//  Created by Yamada Shunya on 2020/01/27.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

public struct BusTime: Decodable {
    public let hour: Int
    public let minute: Int
    
    private enum CodingKeys: String, CodingKey {
        case hour
        case minute
    }
    
    // let dir = DateInRegion(date: Date())
    // let busTimeDir = DateInRegion(year: dir.year, ...)
    // let intervalOfSecond = dir.getInterval(toDate: busTimeDir, component: .second)
}
