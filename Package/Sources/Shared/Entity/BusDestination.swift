//
//  BusDestination.swift
//  
//
//  Created by Shunya Yamada on 2022/11/05.
//

import Foundation

/// バスの行き先を定義した Enum.
///
/// この Enum の `rawValue` を利用してダイヤのコレクションにアクセスする.
public enum BusDestination: String {
    /// 大学行き.
    case toCollege = "ToCollege"
    /// 浄水駅行き.
    case toStation = "ToStation"
}
