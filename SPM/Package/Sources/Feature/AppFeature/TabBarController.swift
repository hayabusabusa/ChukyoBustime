//
//  TabBarController.swift
//  
//
//  Created by Shunya Yamada on 2023/03/05.
//

import ToDestinationFeature
import UIKit

final class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
}

private extension TabBarController {
    func configureViewControllers() {
        let toCollegeVC = ToDestinationViewController(dependency: ToDestinationViewController.Dependency(destination: .toCollege))
        let toCollegeTabBarItem = UITabBarItem(title: "大学行き", image: nil, tag: 0)
        toCollegeVC.tabBarItem = toCollegeTabBarItem

        let toStationVC = ToDestinationViewController(dependency: ToDestinationViewController.Dependency(destination: .toStation))
        let toStationTabBarItem = UITabBarItem(title: "浄水駅行き", image: nil, tag: 0)
        toStationVC.tabBarItem = toStationTabBarItem

        setViewControllers([
            UINavigationController(rootViewController: toCollegeVC),
            UINavigationController(rootViewController: toStationVC)
        ], animated: false)
    }
}
