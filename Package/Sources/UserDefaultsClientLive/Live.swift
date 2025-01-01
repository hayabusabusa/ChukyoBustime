//
//  Live.swift
//  Package
//
//  Created by Shunya Yamada on 2024/12/11.
//

import Dependencies
import Foundation
import UserDefaultsClient

extension UserDefaultsClient: DependencyKey {
    public static var liveValue: UserDefaultsClient {
        Self.live()
    }

    private static func live() -> Self {
        .init { key in
            UserDefaults.standard.integer(forKey: key)
        } setInteger: { value, key in
            UserDefaults.standard.set(value, forKey: key)
        }
    }
}
