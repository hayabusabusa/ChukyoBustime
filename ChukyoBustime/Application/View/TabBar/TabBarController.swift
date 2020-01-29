//
//  TabBarController.swift
//  ChukyoBustime
//
//  Created by Yamada Shunya on 2020/01/29.
//  Copyright © 2020 Shunya Yamada. All rights reserved.
//

import UIKit

final class TabBarController: UITabBarController {
    
    // MARK: IBOutlet
    
    // MARK: Properties
    
    // MARK: Lifecycle
    
    static func instantiate() -> TabBarController {
        return Storyboard.TabBarController.instantiate(TabBarController.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAppearance()
        setupViewControllers()
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
        toCollege.tabBarItem = UITabBarItem(title: "大学行き", image: UIImage(named: "ic_bus"), tag: 1)
        viewControllers = [toStation, toCollege]
    }
}
