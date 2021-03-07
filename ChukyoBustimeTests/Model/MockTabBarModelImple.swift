//
//  MockTabBarModelImple.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/04.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import RxSwift
@testable import ChukyoBustime

final class MockTabBarModelImpl: TabBarModel {
    private let initialTab: TabBarItem
    
    init(initialTab: TabBarItem) {
        self.initialTab = initialTab
    }

    func getInitialTab() -> TabBarItem {
        return initialTab
    }
}
