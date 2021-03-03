//
//  TabBarViewModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/04/23.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Protocols

protocol TabBarViewModelInputs {
    
}

protocol TabBarViewModelOutputs {
    var selectedTab: Driver<Int> { get }
}

protocol TabBarViewModelType {
    var input: TabBarViewModelInputs { get }
    var output: TabBarViewModelOutputs { get }
}

// MARK: - ViewModel

final class TabBarViewModel: TabBarViewModelInputs, TabBarViewModelOutputs {
    
    // MARK: Dependency
    
    private let model: TabBarModel
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private let selectedTabRelay: BehaviorRelay<Int>
    
    let selectedTab: Driver<Int>
    
    // MARK: Initializer
    
    init(model: TabBarModel = TabBarModelImpl()) {
        self.model = model
        self.selectedTabRelay = .init(value: model.getInitialTab().rawValue)
        
        selectedTab = selectedTabRelay.asDriver()
    }
}

extension TabBarViewModel: TabBarViewModelType {
    var input: TabBarViewModelInputs { return self }
    var output: TabBarViewModelOutputs { return self }
}
