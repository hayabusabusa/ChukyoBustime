//
//  SettingModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/02/12.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra
import RxSwift
import RxCocoa

// MARK: - Interface

protocol SettingModel: AnyObject {
    func getSettings() -> [SettingSectionType]
    func saveTabSetting(tabBarItem: TabBarItem)
}

// MARK: - Implementation

class SettingModelImpl: SettingModel {
    
    // MARK: Dependency
    
    private let userDefaultsProvider: UserDefaultsProvider
    
    // MARK: Initializer
    
    init(userDefaultsProvider: UserDefaultsProvider = UserDefaultsProvider.shared) {
        self.userDefaultsProvider = userDefaultsProvider
    }
    
    // MARK: Setting
    
    func getSettings() -> [SettingSectionType] {
        let storedTabSetting = userDefaultsProvider.enumObject(type: TabBarItem.self, forKey: .initialTab) ?? TabBarItem.toStation
        let version = Bundle.main.bundleShortVersionString ?? "unknown"
        return [
            .config(rows: [
                .tabSetting(setting: storedTabSetting.title)
            ]),
            .about(rows: [
                .version(version: version),
                .agreement,
                .repository
            ])
        ]
    }
    
    func saveTabSetting(tabBarItem: TabBarItem) {
        userDefaultsProvider.setEnum(value: tabBarItem, forKey: .initialTab)
    }
}
