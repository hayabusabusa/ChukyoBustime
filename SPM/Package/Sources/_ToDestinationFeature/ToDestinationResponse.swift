//
//  ToDestinationResponse.swift
//  Package
//
//  Created by shuyamad on 2024/12/20.
//

import Foundation
import Shared

/// 行先画面の Firestore 関連処理で取得したデータのまとめ.
public struct ToDestinationResponse: Equatable {
    /// その日のダイヤのデータ.
    public var busDate: BusDate
    /// ダイヤに紐づく時刻表のデータ一覧.
    public var busTimes: [BusTime]

    public init(
        busDate: BusDate,
        busTimes: [BusTime]
    ) {
        self.busDate = busDate
        self.busTimes = busTimes
    }
}
