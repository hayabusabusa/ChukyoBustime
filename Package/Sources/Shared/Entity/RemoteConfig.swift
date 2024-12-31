//
//  RemoteConfig.swift
//  
//
//  Created by Shunya Yamada on 2022/11/05.
//

import Foundation

/// Firebase Remote Config に保存している PDF の参照先をまとめたデータ.
public struct RemoteConfig: Decodable {
    /// カレンダーの PDF の URL.
    public let calendar: String
    /// 時刻表の PDF の URL.
    public let timeTable: String

    private enum CodingKeys: String, CodingKey {
        case calendar
        case timeTable = "time_table"
    }
}
