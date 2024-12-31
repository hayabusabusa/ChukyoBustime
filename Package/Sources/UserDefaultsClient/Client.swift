//
//  Client.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/11.
//

import Dependencies
import DependenciesMacros
import Foundation

@DependencyClient
public struct UserDefaultsClient {
    /// `UserDefaults` に保存されている `Int` の値を返す.
    public var integer: @Sendable (_ key: String) -> Int?
    /// `Int` の値を `UserDefaults` に保存する.
    public var setInteger: @Sendable (_ value: Int, _ key: String) -> Void
}

public extension UserDefaultsClient {
    /// `UserDefaults` に保存されている `RawRepresentable` に準拠した Enum の値を返す.
    /// - Parameter key: 保存するキー.
    /// - Returns: Enum の値.
    func rawRepresentable<R: RawRepresentable>(forKey key: String) -> R? where R.RawValue == Int {
        integer(key: key).flatMap { R.init(rawValue: $0) }
    }
    
    /// `RawRepresentable` に準拠した Enum の値を `UserDefaults` に保存する.
    /// - Parameters:
    ///   - value: Enum の値.
    ///   - key: 保存するキー.
    func setRawRepresentable<R: RawRepresentable>(_ value: R, forKey key: String) where R.RawValue == Int {
        setInteger(value: value.rawValue, key: key)
    }
    
    /// アプリ起動時に表示するタブのインデックスを返す.
    var initialTab: Int? {
        integer(key: initialTabKey)
    }
    
    /// アプリ起動時に表示するタブのインデックスを保存する.
    /// - Parameter integer: タブのインデックス.
    func setInitialTab(_ integer: Int) {
        setInteger(
            value: integer,
            key: initialTabKey
        )
    }
}

// MARK: - Dependency

extension UserDefaultsClient: TestDependencyKey {
    public static var previewValue: UserDefaultsClient {
        .init { _ in
            0
        } setInteger: { _, _ in
            // 何もしない.
        }
    }

    public static var testValue: UserDefaultsClient = Self.init()
}

extension DependencyValues {
    public var userDefaultsClient: UserDefaultsClient {
        get { self[UserDefaultsClient.self] }
        set { self[UserDefaultsClient.self] = newValue }
    }
}

private let initialTabKey = "initialTab"
