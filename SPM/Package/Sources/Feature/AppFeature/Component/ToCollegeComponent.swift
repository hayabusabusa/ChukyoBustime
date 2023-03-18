//
//  ToCollegeComponent.swift
//  
//
//  Created by Shunya Yamada on 2023/03/15.
//

import UIKit
import NeedleFoundation
import ServiceProtocol
import Shared
import ToDestinationFeature

protocol ToCollegeDependency: Dependency {
    var dateService: DateServiceProtocol { get }
    var fileService: FileServiceProtocol { get }
    var firestoreService: FirestoreServiceProtocol { get }
    var remoteConfigService: RemoteConfigServiceProtocol { get }
    var userNotificationService: UserNotificationServiceProtocol { get }
    var toCollegeRouter: ToDestinationRouterProtocol { get }
}

final class ToCollegeComponent: Component<ToCollegeDependency> {
    var settingRouter: SettingRouterProtocol {
        SettingRouter(component: settingComponent)
    }
}

// MARK: Components

extension ToCollegeComponent: ViewControllerBuilder {
    var settingComponent: SettingComponent {
        SettingComponent(parent: self)
    }

    var viewController: UIViewController {
        ToDestinationViewController(dependency: ToDestinationViewController.Dependency(destination: .toCollege))
    }
}
