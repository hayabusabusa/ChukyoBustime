//
//  RootComponent.swift
//  
//
//  Created by Shunya Yamada on 2023/03/15.
//

import NeedleFoundation
import Service
import ServiceProtocol
import Shared
import ToDestinationFeature
import UIKit

final class RootComponent: BootstrapComponent {
    var dateService: DateServiceProtocol {
        DateService()
    }

    var fileService: FileServiceProtocol {
        FileService.shared
    }

    var firestoreService: FirestoreServiceProtocol {
        FirestoreService.shared
    }

    var remoteConfigService: RemoteConfigServiceProtocol {
        RemoteConfigService.shared
    }

    var userDefaultsService: UserDefaultsServiceProtocol {
        UserDefaultsService()
    }

    var userNotificationService: UserNotificationServiceProtocol {
        UserNotificationService.shared
    }

    var toCollegeRouter: ToDestinationRouterProtocol {
        ToCollegeRouter(component: toCollegeComponent)
    }

    var toStationRouter: ToDestinationRouterProtocol {
        ToStationRouter(component: toStationComponent)
    }
}

// MARK: - Components

extension RootComponent {
    var toCollegeComponent: ToCollegeComponent {
        ToCollegeComponent(parent: self)
    }

    var toStationComponent: ToStationComponent {
        ToStationComponent(parent: self)
    }

    var rootViewController: UIViewController {
        TabBarController(toCollegeViewController: toCollegeComponent.viewController,
                         toStationViewController: toStationComponent.viewController)
    }
}
