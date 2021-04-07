//
//  TabBarModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/04/23.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxRelay
import Infra

// MARK: - Interface

protocol TabBarModel: AnyObject {
    /// Emits tab bar item enum object.
    var initialTabStream: Observable<TabBarItem> { get }
}

// MARK: - Implementation

class TabBarModelImpl: TabBarModel {
    
    // MARK: Properties
    
    private let userDefaultsProvider: UserDefaultsProvider
    
    private let initialTabRelay: BehaviorRelay<TabBarItem>
    
    let initialTabStream: Observable<TabBarItem>
    
    // MARK: Initializer
    
    init(userDefaultsProvider: UserDefaultsProvider = UserDefaultsProvider.shared) {
        self.userDefaultsProvider = userDefaultsProvider
        self.initialTabRelay = .init(value: userDefaultsProvider.enumObject(type: TabBarItem.self, forKey: .initialTab) ?? .toStation)
        
        initialTabStream = initialTabRelay.asObservable()
    }
}
