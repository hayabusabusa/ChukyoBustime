//
//  ToDestinationState.swift
//  Package
//
//  Created by Shunya Yamada on 2025/01/02.
//

import Foundation
import Shared

public extension ToDestinationReducer.State {
    /// 表示用に 3 件までに配列を区切った時刻表のデータ一覧.
    var slicedBusTimes: [BusTime] {
        busTimes.suffix(3)
    }
}
