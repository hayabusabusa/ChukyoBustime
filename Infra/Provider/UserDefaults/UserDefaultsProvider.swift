//
//  UserDefaultsProvider.swift
//  Infra
//
//  Created by 山田隼也 on 2020/04/22.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

public final class UserDefaultsProvider {
    
    // MARK: Singletone
    
    public static let shared: UserDefaultsProvider = .init()
    
    // MARK: Properties
    
    private let userDefaults: UserDefaults
    
    public enum Key: String {
        case initialTab
        case aboutNotification
    }
    
    // MARK: Initializer
    
    private init() {
        userDefaults = UserDefaults.standard
    }
    
    // MARK: Save
    
    public func set(value: Any, forKey key: Key) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    public func setEnum<T: RawRepresentable>(value: T, forKey key: Key) {
        userDefaults.set(value.rawValue, forKey: key.rawValue)
    }
    
    public func setEncodable<T: Encodable>(value: T, forKey key: Key) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        userDefaults.set(data, forKey: key.rawValue)
    }
    
    // MARK: Load
    
    public func object<T>(type: T.Type, forKey key: Key) -> T? {
        return userDefaults.object(forKey: key.rawValue) as? T
    }
    
    public func enumObject<T: RawRepresentable>(type: T.Type, forKey key: Key) -> T? {
        guard let rawValue = userDefaults.object(forKey: key.rawValue) as? T.RawValue else { return nil }
        return T.init(rawValue: rawValue)
    }
    
    public func decodableObject<T: Decodable>(type: T.Type, forKey key: Key) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    // MARK: Remove
    
    public func removeObject(forKey key: Key) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
