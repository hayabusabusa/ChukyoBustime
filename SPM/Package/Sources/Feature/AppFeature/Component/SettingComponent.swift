//
//  SettingComponent.swift
//  
//
//  Created by Shunya Yamada on 2023/03/17.
//

import UIKit
import NeedleFoundation
import ServiceProtocol
import Shared
import SettingFeature

protocol SettingDependency: Dependency {
    var userDefaultsService: UserDefaultsServiceProtocol { get }
}

final class SettingComponent: Component<SettingDependency>, ViewControllerBuilder {
    var router: SettingRouterProtocol {
        SettingRouter(component: self)
    }

    var viewController: UIViewController {
        SettingViewController(userDefaultsService: dependency.userDefaultsService,
                              router: router)
    }
}
