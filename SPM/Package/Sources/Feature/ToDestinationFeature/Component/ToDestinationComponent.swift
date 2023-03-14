//
//  ToDestinationComponent.swift
//  
//
//  Created by Shunya Yamada on 2023/03/13.
//

import UIKit
import NeedleFoundation
import ServiceProtocol
import Shared

public protocol ToDestinationDependency: Dependency {
    var dateService: DateServiceProtocol { get }
    var fileService: FileServiceProtocol { get }
    var firestoreService: FirestoreServiceProtocol { get }
    var remoteConfigService: RemoteConfigServiceProtocol { get }
    var userNotificationService: UserNotificationServiceProtocol { get }
    var router: ToDestinationRouterProtocol { get }
}

public protocol ToDestinationBuilder {
    var viewController: UIViewController { get }
}

public final class ToDestinationComponent: Component<ToDestinationDependency>, ToDestinationBuilder {
    public let destination: BusDestination

    public var viewController: UIViewController {
        ToDestinationViewController(dependency: ToDestinationViewController.Dependency(destination: destination))
    }

    public init(parent: Scope,
                destination: BusDestination) {
        self.destination = destination
        super.init(parent: parent)
    }
}
