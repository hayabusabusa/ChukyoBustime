//
//  Client.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/12.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct DateClient {
    /// 現在時刻の `Date` を返す.
    public var now: @Sendable () -> Date = { Date() }
    /// 現在時刻を 00:00 から経過した秒数に直したものを返す.
    public var nowTimeForSeconds: @Sendable () -> Int = { 0 }
    /// 現在の年月日で、時間と分を指定した日付を返す.
    public var today: @Sendable (_ hour: Int, _ minute: Int) -> Date = { _, _ in Date() }
    /// 指定された日付をフォーマットした文字列にして返す.
    public var formatted: @Sendable (_ date: Date, _ format: String) -> String = { _, _ in "" }
}

public extension DateClient {
    /// 指定された日付を `yyyy-MM-dd` のフォーマットにした文字列に変換して返す.
    /// - Parameter date: 変換する日付.
    /// - Returns: `yyyy-MM-dd` の文字列.
    func formattedByYearMonthDay(_ date: Date) -> String {
        formatted(date: date, format: "yyyy-MM-dd")
    }
}

// MARK: - Dependency

extension DateClient: TestDependencyKey {
    public static var previewValue: DateClient {
        .init {
            Date()
        } nowTimeForSeconds: {
            0
        } today: { hour, minute in
            Date()
        } formatted: { date, format in
            ""
        }
    }

    public static var testValue: DateClient = Self.init()
}

extension DependencyValues {
    public var dateClient: DateClient {
        get { self[DateClient.self] }
        set { self[DateClient.self] = newValue }
    }
}
