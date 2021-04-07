//
//  MockTabBarModelImple.swift
//  ChukyoBustimeTests
//
//  Created by Shunya Yamada on 2021/03/04.
//  Copyright © 2021 Shunya Yamada. All rights reserved.
//

import RxSwift
import RxRelay
@testable import ChukyoBustime

final class MockTabBarModelImpl: TabBarModel {
    private let initialTabRelay: BehaviorRelay<TabBarItem>
    
    let initialTabStream: Observable<TabBarItem>
    
    init(initialTab: TabBarItem) {
        self.initialTabRelay = .init(value: initialTab)
        
        initialTabStream = initialTabRelay.asObservable()
    }
}
