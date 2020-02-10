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
    
    // MARK: IBOutlet
    
    // MARK: Properties
    
    private var viewModel: RootViewModel!
    
    // MARK: Lifecycle
    
    static func instantiate() -> RootViewController {
        return Storyboard.RootViewController.instantiate(RootViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
}

// MARK: - ViewModel

extension RootViewController {
    
    private func bindViewModel() {
        let viewModel = RootViewModel()
        self.viewModel = viewModel
        
        let input = RootViewModel.Input(viewDidAppear: rx.viewDidAppear.take(1).asSignal(onErrorSignalWith: .empty()))
        let output = viewModel.transform(input: input)
        
        output.replaceRootToTabBar
            .drive(onNext: { [weak self] in self?.replaceRootToTabBar() })
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
