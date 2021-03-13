//
//  MockSettingModelImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/07.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import RxSwift
import RxRelay
@testable import ChukyoBustime

final class MockSettingModelImpl: SettingModel {
    
    private var tabSetting: TabBarItem
    private let sections: [SettingSectionType]?
    
    let messageRelay: PublishRelay<String>
    let sectionsRelay: BehaviorRelay<[SettingSectionType]>
    
    init(tabSetting: TabBarItem, sections: [SettingSectionType]? = nil) {
        self.tabSetting = tabSetting
        self.sections = sections
        self.messageRelay = .init()
        self.sectionsRelay = .init(value: [])
    }
    
    func getSettings() {
        sectionsRelay.accept(sections ?? Mock.createSettingSections(tabSetting: tabSetting))
    }
    
    func saveTabSetting(tabBarItem: TabBarItem) {
        tabSetting = tabBarItem
        getSettings()
        messageRelay.accept("起動時に表示する画面を\n \(tabBarItem.title) の画面に設定しました。")
    }
}
