//
//  BusTime.swift
//  
//
//  Created by Shunya Yamada on 2022/11/05.
//

import Foundation

/// Firestore に保存している各ダイヤのコレクションに入っているデータ.
public struct BusTime: Codable {
    /// バスが来る時刻の時間.
    public let hour: Int
    /// バスが来る時刻の分.
    public let minute: Int
    /// バスが来る時刻を秒数に計算し直したもの.
    ///
    /// 12時30分にバスが来る場合は `12 * 3600 + 330 * 60 = 45000` になる.
    public let second: Int
    /// バスが到着する時刻の時間.
    public let arrivalHour: Int
    /// バスが到着する時刻の分.
    public let arrivalMinute: Int
    /// バスが到着する時刻を秒数に計算し直したもの.
    ///
    /// 12時30分にバスが到着する場合は `12 * 3600 + 330 * 60 = 45000` になる.
    public let arrivalSecond: Int
    /// 折り返し運行かどうか.
    public let isReturn: Bool
    /// その日の最終バスかどうか.
    public let isLast: Bool
    /// 貝津駅経由かどうか.
    public let isKaizu: Bool

    public init(hour: Int,
                minute: Int,
                second: Int,
                arrivalHour: Int,
                arrivalMinute: Int,
                arrivalSecond: Int,
                isReturn: Bool,
                isLast: Bool,
                isKaizu: Bool) {
        self.hour = hour
        self.minute = minute
        self.second = second
        self.arrivalHour = arrivalHour
        self.arrivalMinute = arrivalMinute
        self.arrivalSecond = arrivalSecond
        self.isReturn = isReturn
        self.isLast = isLast
        self.isKaizu = isKaizu
    }
}
