//
//  ToCollegeRouter.swift
//  
//
//  Created by Shunya Yamada on 2023/03/18.
//

import UIKit
import Shared

final class ToCollegeRouter: ToDestinationRouterProtocol {
    var component: ToCollegeComponent
    var viewController: UIViewController?

    init(component: ToCollegeComponent) {
        self.component = component
        self.viewController = component.viewController
    }

    func transitionToSettings() {
        let settingViewController = component.settingComponent.viewController
        viewController?.present(settingViewController, animated: true)
    }
}
