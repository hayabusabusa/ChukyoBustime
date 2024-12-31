//
//  Client.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/07.
//

import Dependencies
import DependenciesMacros
import Foundation
import Shared

@DependencyClient
public struct FirestoreClient: Sendable {
    /// バスのカレンダーのコレクションからその日の運行情報のデータを取得する.
    ///
    /// - note: 取得する日付を `yyyy-MM-dd` でフォーマットした文字列を渡す.
    public var fetchBusDate: @Sendable (_ date: String) async throws -> BusDate
    /// ダイヤのコレクションからダイヤに紐づくデータ一覧を取得する.
    public var fetchBusTimes: @Sendable (_ diagram: String, _ destination: BusDestination, _ second: Int) async throws -> [BusTime]
}

extension FirestoreClient: TestDependencyKey {
    public static var previewValue: FirestoreClient {
        .init { _ in
            BusDate(
                diagram: "A",
                diagramName: "Aダイヤ"
            )
        } fetchBusTimes: { (_, _, _) in
            [
                BusTime(
                    hour: 23,
                    minute: 59,
                    second: 86399,
                    arrivalHour: 24,
                    arrivalMinute: 0,
                    arrivalSecond: 86400,
                    isReturn: true,
                    isLast: true,
                    isKaizu: true
                )
            ]
        }
    }

    public static var testValue: FirestoreClient = Self()
}

extension DependencyValues {
    public var firestoreClient: FirestoreClient {
        get { self[FirestoreClient.self] }
        set { self[FirestoreClient.self] = newValue }
    }
}
