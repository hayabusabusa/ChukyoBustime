//
//  BusTime.swift
//  Infrastructure
//
//  Created by Yamada Shunya on 2020/01/27.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

public struct BusTime {
    public let seconds: Int // 00:00 からの経過時間
    public var time: String {
        return String(format: "%d:%d", seconds / 3600, seconds / 60)
    }
    
    public init(seconds: Int) {
        self.seconds = seconds
    }
}
