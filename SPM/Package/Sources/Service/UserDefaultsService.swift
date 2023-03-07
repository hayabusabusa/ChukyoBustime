//
//  UserDefaultsService.swift
//  
//
//  Created by Shunya Yamada on 2022/11/02.
//

import Foundation
import ServiceProtocol
import Shared

/// UserDefaults に保存したデータの読み書きを行う Service.
public struct UserDefaultsService: UserDefaultsServiceProtocol {

    private let userDefaults: UserDefaults

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func set(value: Any, forKey key: UserDefaultsKey) {
        userDefaults.set(value, forKey: key.rawValue)
    }

    public func set<T>(value: T, forKey key: UserDefaultsKey) where T: RawRepresentable {
        userDefaults.set(value.rawValue, forKey: key.rawValue)
    }

    public func object<T>(type: T.Type, forKey key: UserDefaultsKey) -> T? {
        userDefaults.object(forKey: key.rawValue) as? T
    }

    public func object<T>(type: T.Type, forKey key: UserDefaultsKey) -> T? where T: RawRepresentable {
        guard let rawValue = userDefaults.object(forKey: key.rawValue) as? T.RawValue else { return nil }
        return T.init(rawValue: rawValue)
    }

    public func removeObject(forKey key: UserDefaultsKey) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
