//
//  ToStationComponent.swift
//  
//
//  Created by Shunya Yamada on 2023/03/15.
//

import UIKit
import NeedleFoundation
import ServiceProtocol
import Shared
import ToDestinationFeature

protocol ToStationDependency: Dependency {
    var dateService: DateServiceProtocol { get }
    var fileService: FileServiceProtocol { get }
    var firestoreService: FirestoreServiceProtocol { get }
    var remoteConfigService: RemoteConfigServiceProtocol { get }
    var userNotificationService: UserNotificationServiceProtocol { get }
    var toStationRouter: ToDestinationRouterProtocol { get }
}

final class ToStationComponent: Component<ToStationDependency> {
    var settingRouter: SettingRouterProtocol {
        SettingRouter(component: settingComponent)
    }
}

// MARK: Components

extension ToStationComponent: ViewControllerBuilder {
    var settingComponent: SettingComponent {
        SettingComponent(parent: self)
    }

    var viewController: UIViewController {
        ToDestinationViewController(destination: .toStation,
                                    dateService: dependency.dateService,
                                    fileService: dependency.fileService,
                                    firestoreService: dependency.firestoreService,
                                    remoteConfigService: dependency.remoteConfigService,
                                    router: dependency.toStationRouter)
    }
}
