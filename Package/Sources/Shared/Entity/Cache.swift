//
//  Cache.swift
//  
//
//  Created by Shunya Yamada on 2022/11/05.
//

import Foundation

/// Firestore から取得したデータをローカルに保存するキャッシュ.
///
/// 主に Widget からの利用を想定.
public struct Cache: Codable {
    /// バスのダイヤのデータ.
    public let busDate: BusDate
    /// バスの時刻のデータ.
    public let busTimes: [BusTime]
    /// 最終更新日.
    ///
    /// `yyyy-MM-dd` のフォーマット.
    public let lastUpdatedDate: String

    public init(busDate: BusDate,
                busTimes: [BusTime],
                lastUpdatedDate: String) {
        self.busDate = busDate
        self.busTimes = busTimes
        self.lastUpdatedDate = lastUpdatedDate
    }
}
