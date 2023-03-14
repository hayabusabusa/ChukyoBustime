//
//  TabBarController.swift
//  
//
//  Created by Shunya Yamada on 2023/03/05.
//

import ToDestinationFeature
import UIKit

final class TabBarController: UITabBarController {

    // MARK: Properties

    private let toCollegeViewController: UIViewController
    private let toStationViewController: UIViewController

    // MARK: Lifecycle

    public init(toCollegeViewController: UIViewController,
                toStationViewController: UIViewController) {
        self.toCollegeViewController = toCollegeViewController
        self.toStationViewController = toStationViewController
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
    }
}

private extension TabBarController {
    func configureViewControllers() {
        let toCollegeNavigationViewController = UINavigationController(rootViewController: toCollegeViewController)
        let toCollegeTabBarItem = UITabBarItem(title: "大学行き", image: nil, tag: 0)
        toCollegeNavigationViewController.tabBarItem = toCollegeTabBarItem

        let toStationNavigationViewController = UINavigationController(rootViewController: toStationViewController)
        let toStationTabBarItem = UITabBarItem(title: "浄水駅行き", image: nil, tag: 1)
        toStationNavigationViewController.tabBarItem = toStationTabBarItem

        setViewControllers([
            toCollegeNavigationViewController,
            toStationNavigationViewController
        ], animated: false)
    }
}
