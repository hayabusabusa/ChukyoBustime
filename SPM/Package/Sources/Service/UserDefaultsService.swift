//
//  UserDefaultsService.swift
//  
//
//  Created by Shunya Yamada on 2022/11/02.
//

import Foundation

public protocol UserDefaultsServiceProtocol {
    /// プリミティブな値を保存する.
    /// - Parameters:
    ///   - value: `Any` に該当する値.
    ///   - key: 保存する際のキー.
    func set(value: Any, forKey key: UserDefaultsService.Key)

    /// Enum で定義された値を保存する.
    /// - Parameters:
    ///   - value: Enum の値.
    ///   - key: 保存する際のキー.
    func set<T: RawRepresentable>(value: T, forKey key: UserDefaultsService.Key)

    /// 保存されているプリミティブな値を読み込む.
    /// - Parameters:
    ///   - type: 読み込む値の型.
    ///   - key: 保存する際に指定したキー.
    /// - Returns: 保存されている値.
    func object<T>(type: T.Type, forKey key: UserDefaultsService.Key) -> T?

    /// 保存されている Enum の値を読み込む.
    /// - Parameters:
    ///   - type: 読み込む値の型.
    ///   - key: 保存する際に指定したキー.
    /// - Returns: 保存されている値.
    func object<T: RawRepresentable>(type: T.Type, forKey key: UserDefaultsService.Key) -> T?

    /// 保存されている値を削除する.
    /// - Parameter key: 保存する際に指定したキー.
    func removeObject(forKey key: UserDefaultsService.Key)
}

/// UserDefaults に保存したデータの読み書きを行う Service.
public struct UserDefaultsService: UserDefaultsServiceProtocol {

    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func set(value: Any, forKey key: Key) {
        userDefaults.set(value, forKey: key.rawValue)
    }

    public func set<T>(value: T, forKey key: Key) where T: RawRepresentable {
        userDefaults.set(value.rawValue, forKey: key.rawValue)
    }

    public func object<T>(type: T.Type, forKey key: Key) -> T? {
        userDefaults.object(forKey: key.rawValue) as? T
    }

    public func object<T>(type: T.Type, forKey key: Key) -> T? where T: RawRepresentable {
        guard let rawValue = userDefaults.object(forKey: key.rawValue) as? T.RawValue else { return nil }
        return T.init(rawValue: rawValue)
    }

    public func removeObject(forKey key: Key) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}

public extension UserDefaultsService {
    /// UserDefaults で保存する際のキー.
    enum Key: String, CaseIterable {
        /// 初回起動時に表示するタブのインデックスを保存するキー.
        case initialTab
    }
}
