//
//  SettingRouter.swift
//  
//
//  Created by Shunya Yamada on 2023/03/18.
//

import UIKit
import Shared
import SettingFeature

final class SettingRouter: SettingRouterProtocol {
    var viewController: UIViewController?

    init(component: SettingComponent) {
        self.viewController = component.viewController
    }

    func dismiss() {
        viewController?.dismiss(animated: true)
    }
}
