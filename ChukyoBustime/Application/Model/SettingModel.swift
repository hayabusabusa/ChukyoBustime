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
    /// Emits message about error or other.
    var messageRelay: PublishRelay<String> { get }
    
    /// Emits `SettingSectionType` enum array.
    var sectionsRelay: BehaviorRelay<[SettingSectionType]> { get }
    
    /// Get `UserDefaults` value and create `SettingSectionType` enum array.
    func getSettings()
    
    /// Save tab bar setting to `UserDefaults`.
    /// - Parameter tabBarItem: `TabBarItem ` enum.
    func saveTabSetting(tabBarItem: TabBarItem)
}

// MARK: - Implementation

class SettingModelImpl: SettingModel {
    
    // MARK: Properies
    
    private let disposeBag = DisposeBag()
    private let userDefaultsProvider: UserDefaultsProvider
    
    let messageRelay: PublishRelay<String>
    let sectionsRelay: BehaviorRelay<[SettingSectionType]>
    
    // MARK: Initializer
    
    init(userDefaultsProvider: UserDefaultsProvider = UserDefaultsProvider.shared) {
        self.messageRelay = .init()
        self.sectionsRelay = .init(value: [])
        self.userDefaultsProvider = userDefaultsProvider
    }
    
    // MARK: UserDefaults
    
    func getSettings() {
        let storedTabSetting = userDefaultsProvider.enumObject(type: TabBarItem.self, forKey: .initialTab) ?? TabBarItem.toStation
        let version = Bundle.main.bundleShortVersionString ?? "unknown"
        let sections: [SettingSectionType] = [
            .config(rows: [
                .tabSetting(setting: storedTabSetting.title)
            ]),
            .about(rows: [
                .version(version: version),
                .app,
                .precations,
                .privacyPolicy
            ])
        ]
        sectionsRelay.accept(sections)
    }
    
    func saveTabSetting(tabBarItem: TabBarItem) {
        userDefaultsProvider.setEnum(value: tabBarItem, forKey: .initialTab)
        
        // NOTE: TableView を更新する
        getSettings()
        messageRelay.accept("起動時に表示する画面を\n \(tabBarItem.title) の画面に設定しました。")
    }
}
