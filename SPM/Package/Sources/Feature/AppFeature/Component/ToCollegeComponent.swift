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
}

final class ToCollegeComponent: Component<ToCollegeDependency>, ViewControllerBuilder {
    var router: ToDestinationRouterProtocol {
        ToCollegeRouter(component: self)
    }
}

// MARK: Components

extension ToCollegeComponent {
    var settingComponent: SettingComponent {
        SettingComponent(parent: self)
    }

    var viewController: UIViewController {
        ToDestinationViewController(destination: .toCollege,
                                    dateService: dependency.dateService,
                                    fileService: dependency.fileService,
                                    firestoreService: dependency.firestoreService,
                                    remoteConfigService: dependency.remoteConfigService,
                                    router: router)
    }
}
