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
    
    private let messageRelay: PublishRelay<String>
    private let sectionsRelay: BehaviorRelay<[SettingSectionType]>
    
    let messageStream: Observable<String>
    let sectionsStream: Observable<[SettingSectionType]>
    
    init(tabSetting: TabBarItem, sections: [SettingSectionType]? = nil) {
        self.tabSetting = tabSetting
        self.sections = sections
        self.messageRelay = .init()
        self.sectionsRelay = .init(value: [])
        
        messageStream = messageRelay.asObservable()
        sectionsStream = sectionsRelay.asObservable()
    }
    
    func getSettings() {
        sectionsRelay.accept(sections ?? Stub.createSettingSections(tabSetting: tabSetting))
    }
    
    func saveTabSetting(tabBarItem: TabBarItem) {
        tabSetting = tabBarItem
        getSettings()
        messageRelay.accept("起動時に表示する画面を\n \(tabBarItem.title) の画面に設定しました。")
    }
}
