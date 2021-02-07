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
    
    private let replaceRootToTabBarRelay: PublishRelay<Void>
    private let disposeBag = DisposeBag()
    
    var replaceRootToTabBar: Signal<Void> {
        return replaceRootToTabBarRelay.asSignal()
    }
    
    // MARK: Initializer
    
    init(model: RootModel = RootModelImpl()) {
        self.model = model
        self.replaceRootToTabBarRelay = .init()
    }
    
    // MARK: Inputs
    
    func viewDidLoad() {
        model.fetchAndActivate()
            .subscribe(onCompleted: { [weak self] in
                self?.replaceRootToTabBarRelay.accept(())
            }, onError: { error in
                print(error)
            })
            .disposed(by: disposeBag)
    }
}

extension RootViewModel: RootViewModelType {
    var input: RootViewModelInputs { return self }
    var output: RootViewModelOutputs { return self }
}
