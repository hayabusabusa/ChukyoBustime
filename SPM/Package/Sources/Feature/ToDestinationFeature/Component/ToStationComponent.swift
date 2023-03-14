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

public protocol ToStationDependency: Dependency {
    var dateService: DateServiceProtocol { get }
    var fileService: FileServiceProtocol { get }
    var firestoreService: FirestoreServiceProtocol { get }
    var remoteConfigService: RemoteConfigServiceProtocol { get }
    var userNotificationService: UserNotificationServiceProtocol { get }
    var toStationRouter: ToDestinationRouterProtocol { get }
}

public final class ToStationComponent: Component<ToStationDependency>, ViewControllerBuilder {
    public var viewController: UIViewController {
        ToDestinationViewController(dependency: ToDestinationViewController.Dependency(destination: .toStation))
    }
}
