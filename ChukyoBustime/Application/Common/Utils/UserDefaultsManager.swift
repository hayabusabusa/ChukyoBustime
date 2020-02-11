//
//  UserDefaultsManager.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

struct UserDefaultsManager {
    
    // MARK: Properties
    
    private let userDefaults = UserDefaults.standard
    
    // MARK: Keys
    
    enum Key: String {
        case selectedTabIndex
    }
    
    // MARK: Load object
    
    func object<T>(of type: T.Type, for key: Key) -> T? {
        guard let object = userDefaults.object(forKey: key.rawValue) as? T else { return nil }
        return object
    }
    
    func decodableObject<T: Decodable>(of type: T.Type, for key: Key) -> T? {
        guard let data = userDefaults.data(forKey: key.rawValue),
            let object = try? JSONDecoder().decode(type.self, from: data) else { return nil }
        return object
    }
    
    // MARK: Save object
    
    func setObject(_ value: Any, for key: Key) {
        userDefaults.set(value, forKey: key.rawValue)
    }
    
    func setCodableObject<T: Codable>(_ value: T, key: Key) {
        guard let data = try? JSONEncoder().encode(value) else { return }
        userDefaults.set(data, forKey: key.rawValue)
    }
    
    // MARK: Remove object
    
    func removeObject(for key: Key) {
        userDefaults.removeObject(forKey: key.rawValue)
    }
}
