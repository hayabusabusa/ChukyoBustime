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

public protocol SettingDependency: Dependency {
    var userDefaultsService: UserDefaultsServiceProtocol { get }
}

public final class SettingComponent: Component<SettingDependency>, ViewControllerBuilder {
    public var viewController: UIViewController {
        SettingViewController()
    }
}
