//
//  MockSettingModelImpl.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/07.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import RxSwift
@testable import ChukyoBustime

final class MockSettingModelImpl: SettingModel {
    
    private var tabSetting: TabBarItem
    private let sections: [SettingSectionType]?
    
    init(tabSetting: TabBarItem, sections: [SettingSectionType]? = nil) {
        self.tabSetting = tabSetting
        self.sections = sections
    }
    
    func getSettings() -> [SettingSectionType] {
        guard let sections = sections else {
            return Mock.createSettingSections(tabSetting: tabSetting)
        }
        return sections
    }
    
    func saveTabSetting(tabBarItem: TabBarItem) {
        tabSetting = tabBarItem
    }
}
