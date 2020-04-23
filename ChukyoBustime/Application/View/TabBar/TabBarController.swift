//
//  TabBarController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class TabBarController: UITabBarController {
    
    // MARK: IBOutlet
    
    // MARK: Properties
    
    private let disposeBag = DisposeBag()
    private var viewModel: TabBarViewModel!
    
    // MARK: Lifecycle
    
    static func instantiate() -> TabBarController {
        return Storyboard.TabBarController.instantiate(TabBarController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupViewControllers()
        bindViewModel()
    }
}

// MARK: - Setup

extension TabBarController {
    
    private func setupAppearance() {
        tabBar.tintColor = .primary
        tabBar.unselectedItemTintColor = UIColor.lightGray.withAlphaComponent(0.6)
        tabBar.backgroundImage = UIImage()
        tabBar.backgroundColor = .background
    }
    
    private func setupViewControllers() {
        let toStation = NavigationController(rootViewController: ToStationViewController.instantiate())
        toStation.tabBarItem = UITabBarItem(title: "浄水駅行き", image: UIImage(named: "ic_train"), tag: 0)
        let toCollege = NavigationController(rootViewController: ToCollegeViewController.instantiate())
        toCollege.tabBarItem = UITabBarItem(title: "大学行き", image: UIImage(named: "ic_school"), tag: 1)
        viewControllers = [toStation, toCollege]
    }
}

// MARK: - ViewModel

extension TabBarController {
    
    private func bindViewModel() {
        let viewModel = TabBarViewModel()
        self.viewModel = viewModel
        
        let output = viewModel.transform(input: TabBarViewModel.Input())
        
        output.selectedTabDriver
            .drive(onNext: { [weak self] index in self?.selectedIndex = index })
            .disposed(by: disposeBag)
    }
}
