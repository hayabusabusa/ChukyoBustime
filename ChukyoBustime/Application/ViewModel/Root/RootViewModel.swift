//
//  RootViewModel.swift
//  ChukyoBustime
//
//  Created by 山田隼也 on 2020/02/10.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

// MARK: - Protocols

protocol RootViewModelInputs {
    /// Call when the view did load..
    func viewDidLoad()
}

protocol RootViewModelOutputs {
    /// Emits a void event to replace root to tab bar controller.
    var replaceRootToTabBar: Signal<Void> { get }
}

protocol RootViewModelType {
    var input: RootViewModelInputs { get }
    var output: RootViewModelOutputs { get }
}

// MARK: - ViewModel

final class RootViewModel: RootViewModelInputs, RootViewModelOutputs {
    
    // MARK: Dependency
    
    private let model: RootModel
    
    // MARK: Properties
    
    let replaceRootToTabBar: Signal<Void>
    
    // MARK: Initializer
    
    init(model: RootModel = RootModelImpl()) {
        self.model = model
        
        // NOTE: 全ての処理が完了時に TabBar に切り替えるので、`Signal` に変換する
        replaceRootToTabBar = model.isCompletedRelay.asSignal()
    }
    
    // MARK: Inputs
    
    func viewDidLoad() {
        model.fetch()
    }
}

extension RootViewModel: RootViewModelType {
    var input: RootViewModelInputs { return self }
    var output: RootViewModelOutputs { return self }
}
