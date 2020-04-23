//
//  SettingSectionType.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/02/12.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation

enum SettingSectionType {
    case config(rows: [SettingCellType])
    case about(rows: [SettingCellType])
    
    enum SettingCellType {
        case tabSetting(setting: String)
        case version(version: String)
        case agreement
        case repository
    }
    
    var rows: [SettingCellType] {
        switch self {
        case .config(let rows): return rows
        case .about(let rows): return rows
        }
    }
    
    var headerTitle: String? {
        switch self {
        case .config: return "アプリの設定"
        case .about: return "このアプリについて"
        }
    }
}
