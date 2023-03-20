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
}

final class ToStationComponent: Component<ToStationDependency> {
    var router: ToDestinationRouterProtocol {
        // ViewController を作るために Router が必要だが、Router も ViewController が必要になっているので無限ループになる.
        // なので一旦 ViewController を nil の状態にして、後から ViewController をセットしたいが、Component から返している ViewController はプロパティにできず
        // Router 側から Component の ViewController を受け取ろうにも getter なので別インスタンスになってしまうというジレンマが発生している.
        ToStationRouter(component: self)
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
                                    router: router)
    }
}
