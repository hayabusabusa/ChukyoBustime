//
//  ToStationRouter.swift
//  
//
//  Created by Shunya Yamada on 2023/03/18.
//

import UIKit
import Shared
import ToDestinationFeature

final class ToStationRouter: ToDestinationRouterProtocol {
    var component: ToStationComponent
    weak var viewController: UIViewController?

    init(component: ToStationComponent) {
        self.component = component
        self.viewController = nil
    }

    func transitionToSettings() {
        let settingViewController = component.settingComponent.viewController
        let navigationController = UINavigationController(rootViewController: settingViewController)
        viewController?.present(navigationController, animated: true)
    }
}
