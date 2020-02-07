//
//  SettingViewController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/02/07.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

final class SettingViewController: BaseViewController {
    
    // MARK: IBOutlet
    
    // MARK: Properties
    
    private var viewModel: SettingViewModel!
    
    // MARK: Lifecycle
    
    static func instantiate() -> SettingViewController {
        return Storyboard.SettingViewController.instantiate(SettingViewController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigation()
        bindViewModel()
    }
}

// MARK: - Setup

extension SettingViewController {
    
    private func setupNavigation() {
        navigationItem.title = "設定"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "閉じる", style: .done, target: nil, action: nil)
    }
}

// MARK: - ViewModel

extension SettingViewController {
    
    private func bindViewModel() {
        let viewModel = SettingViewModel()
        self.viewModel = viewModel
        
        let closeBarButton = navigationItem.rightBarButtonItem!
        let input = SettingViewModel.Input(closeBarButtonDidTap: closeBarButton.rx.tap.asSignal())
        let output = viewModel.transform(input: input)
        
        output.dismiss
            .drive(onNext: { [weak self] in self?.dismiss(animated: true, completion: nil) })
            .disposed(by: disposeBag)
    }
}
