//
//  FirestoreServiceProtocol.swift
//  
//
//  Created by Shunya Yamada on 2023/03/08.
//

import Foundation
import Shared

public protocol FirestoreServiceProtocol {
    /// バスのカレンダーのコレクションから任意の日付のバス運行情報のデータを取得する.
    /// - Parameter request: バスのカレンダーのコレクションからデータを取得するリクエスト.
    /// - Returns: 任意の日付のバス運行情報.
    func busDate(with request: BusDateRequest) async throws -> BusDate

    /// 任意のダイヤのコレクションからデータ一覧を取得する.
    /// - Parameter request: ダイヤのコレクションからデータ一覧を取得するリクエスト.
    /// - Returns: 任意のダイヤのデータ一覧.
    func busTimes(with request: BusTimesRequest) async throws -> [BusTime]
}
