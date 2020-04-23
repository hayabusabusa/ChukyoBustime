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

final class TabBarViewModel {
    
    // MARK: Dependency
    
    private let model: TabBarModel
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    
    // MARK: Initializer
    
    init(model: TabBarModel = TabBarModelImpl()) {
        self.model = model
    }
}

extension TabBarViewModel: ViewModelType {
    
    // MARK: I/O
    
    struct Input {
    }
    
    struct Output {
        let selectedTabDriver: Driver<Int>
    }
    
    // MARK: Transform I/O
    
    func transform(input: Input) -> Output {
        let selectedTabRelay: BehaviorRelay<Int> = .init(value: model.getInitialTab().rawValue)
        return Output(selectedTabDriver: selectedTabRelay.asDriver())
    }
}
