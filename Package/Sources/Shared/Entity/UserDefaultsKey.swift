//
//  UserDefaultsKey.swift
//  
//
//  Created by Shunya Yamada on 2023/03/07.
//

import Foundation

/// UserDefaults で保存する際のキー.
public enum UserDefaultsKey: String, CaseIterable {
    /// 初回起動時に表示するタブのインデックスを保存するキー.
    case initialTab
}
