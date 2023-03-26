//
//  TabBarController.swift
//  
//
//  Created by Shunya Yamada on 2023/03/05.
//

import ServiceProtocol
import ToDestinationFeature
import UIKit

final class TabBarController: UITabBarController {

    // MARK: Properties

    private let toCollegeViewController: UIViewController
    private let toStationViewController: UIViewController
    private let userDefaultsService: UserDefaultsServiceProtocol

    // MARK: Lifecycle

    public init(toCollegeViewController: UIViewController,
                toStationViewController: UIViewController,
                userDefaultsService: UserDefaultsServiceProtocol) {
        self.toCollegeViewController = toCollegeViewController
        self.toStationViewController = toStationViewController
        self.userDefaultsService = userDefaultsService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewControllers()
        configureSelectedIndex()
    }
}

private extension TabBarController {
    func configureViewControllers() {
        let toStationNavigationViewController = UINavigationController(rootViewController: toStationViewController)
        let toStationTabBarItem = UITabBarItem(title: "浄水駅行き", image: nil, tag: 0)
        toStationNavigationViewController.tabBarItem = toStationTabBarItem

        let toCollegeNavigationViewController = UINavigationController(rootViewController: toCollegeViewController)
        let toCollegeTabBarItem = UITabBarItem(title: "大学行き", image: nil, tag: 1)
        toCollegeNavigationViewController.tabBarItem = toCollegeTabBarItem

        setViewControllers([
            toStationNavigationViewController,
            toCollegeNavigationViewController,
        ], animated: false)
    }

    func configureSelectedIndex() {
        selectedIndex = userDefaultsService.object(type: Int.self, forKey: .initialTab) ?? 0
    }
}
