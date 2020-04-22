//
//  UserDefaultsProvider.swift
//  Infra
//
//  Created by 山田隼也 on 2020/04/22.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

final class UserDefaultsProvider {
    
    // MARK: Singletone
    
    static let shared: UserDefaultsProvider = .init()
    
    // MARK: Properties
    
    private let userDefaults: UserDefaults
    
    enum Key: String {
        case tab
    }
    
    // MARK: Initializer
    
    private init() {
        userDefaults = UserDefaults.standard
    }
    
    // MARK: Save
    
    func set(value: Any, forKey key: Key) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func setEnum<T: RawRepresentable>(value: T, forKey key: Key) {
        userDefaults.set(value.rawValue, forKey: key.rawValue)
    }
    
    func setEncodable<T: Encodable>(value: T, forKey key: Key) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        userDefaults.set(data, forKey: key.rawValue)
    }
    
    // MARK: Load
    
    func object<T>(type: T.Type, forKey key: Key) -> T? {
        return userDefaults.object(forKey: key.rawValue) as? T
    }
    
    func enumObject<T: RawRepresentable>(type: T.Type, forKey key: Key) -> T? {
        guard let rawValue = userDefaults.object(forKey: key.rawValue) as? T.RawValue else { return nil }
        return T.init(rawValue: rawValue)
    }
    
    func decodableObject<T: Decodable>(type: T.Type, forKey key: Key) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue) else { return nil }
        return try? JSONDecoder().decode(type, from: data)
    }
    
    // MARK: Remove
    
    func removeObject(forKey key: Key) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
