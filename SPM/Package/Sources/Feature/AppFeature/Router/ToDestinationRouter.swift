//
//  ToDestinationRouter.swift
//  
//
//  Created by Shunya Yamada on 2023/03/15.
//

import Shared
import UIKit

final class ToDestinationRouter: ToDestinationRouterProtocol {
    var viewController: UIViewController?

    init(viewController: UIViewController) {
        self.viewController = viewController
    }

    func transitionToSettings() {
        // TODO: 設定画面へ遷移.
    }
}
