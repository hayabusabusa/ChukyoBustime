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
    weak var viewController: UIViewController?

    init(component: SettingComponent) {
        self.viewController = nil
    }

    func dismiss() {
        viewController?.dismiss(animated: true)
    }

    func transitionToSafariViewController(with url: URL) {
        let vc = SFSafariViewController(url: url)
        viewController?.present(vc, animated: true)
    }

    func presentAlert(with initialTab: Int) {
        let name = initialTab == 0 ? "浄水駅行き" : "大学行き"
        let alertController = UIAlertController(title: "設定完了",
                                                message: "起動時に表示する画面を\n\(name) の画面に設定しました。",
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default))
        viewController?.present(alertController, animated: true)
    }
}
