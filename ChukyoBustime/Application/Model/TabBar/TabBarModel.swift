//
//  TabBarModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/04/23.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import Infra

// MARK: - Interface

protocol TabBarModel: AnyObject {
    func getInitialTab() -> TabBarItem
}

// MARK: - Implementation

class TabBarModelImpl: TabBarModel {
    
    // MARK: Dependency
    
    private let userDefaultsProvider: UserDefaultsProvider
    
    // MARK: Initializer
    
    init(userDefaultsProvider: UserDefaultsProvider = UserDefaultsProvider.shared) {
        self.userDefaultsProvider = userDefaultsProvider
    }
    
    // MARK: UserDefaults
    
    func getInitialTab() -> TabBarItem {
        return userDefaultsProvider.enumObject(type: TabBarItem.self, forKey: .initialTab) ?? .toStation
    }
}
