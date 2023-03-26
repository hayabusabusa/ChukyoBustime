//
//  SettingSection.swift
//  
//
//  Created by Shunya Yamada on 2023/03/20.
//

import Foundation

struct SettingSection: Hashable {
    let title: String
    let items: [SettingItem]
}

enum SettingItem: Hashable {
    case tabSetting(setting: String)
    case version(version: String)
    case about
    case disclaimer
    case privacyPolicy
}
