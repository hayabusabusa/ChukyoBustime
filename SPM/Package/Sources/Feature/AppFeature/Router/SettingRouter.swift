//
//  SettingRouter.swift
//  
//
//  Created by Shunya Yamada on 2023/03/18.
//

import UIKit
import SafariServices
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

    func transitionToSafariViewController(with url: URL) {
        let vc = SFSafariViewController(url: url)
        viewController?.present(vc, animated: true)
    }
}
