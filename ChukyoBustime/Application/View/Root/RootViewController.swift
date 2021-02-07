//
//  RootViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/27.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import RxCocoa

final class RootViewController: BaseViewController {
    
    // MARK: Properties
    
    private let viewModel: RootViewModel = RootViewModel()
    
    // MARK: Lifecycle
    
    static func instantiate() -> RootViewController {
        return Storyboard.RootViewController.instantiate(RootViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindViewModel()
        
        viewModel.input.viewDidLoad()
    }
}

// MARK: - ViewModel

extension RootViewController {
    
    private func bindViewModel() {
        viewModel.output.replaceRootToTabBar
            .emit(onNext: { [weak self] in
                self?.replaceRootToTabBar()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Transition

extension RootViewController {
    
    private func replaceRootToTabBar() {
        let vc = TabBarController.instantiate()
        replaceRoot(to: vc)
    }
}
