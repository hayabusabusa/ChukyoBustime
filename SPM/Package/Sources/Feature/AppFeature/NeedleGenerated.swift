

import NeedleFoundation
import Service
import ServiceProtocol
import Shared
import ToDestinationFeature
import UIKit

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class ToStationDependencyc82a022d3fcc5dcda0c6Provider: ToStationDependency {
    var dateService: DateServiceProtocol {
        return rootComponent.dateService
    }
    var fileService: FileServiceProtocol {
        return rootComponent.fileService
    }
    var firestoreService: FirestoreServiceProtocol {
        return rootComponent.firestoreService
    }
    var remoteConfigService: RemoteConfigServiceProtocol {
        return rootComponent.remoteConfigService
    }
    var userNotificationService: UserNotificationServiceProtocol {
        return rootComponent.userNotificationService
    }
    var toStationRouter: ToDestinationRouterProtocol {
        return rootComponent.toStationRouter
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->ToStationComponent
private func factoryce11505cf466f1bc1658b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ToStationDependencyc82a022d3fcc5dcda0c6Provider(rootComponent: parent1(component) as! RootComponent)
}
private class ToCollegeDependencya102e6c5eb750129b80aProvider: ToCollegeDependency {
    var dateService: DateServiceProtocol {
        return rootComponent.dateService
    }
    var fileService: FileServiceProtocol {
        return rootComponent.fileService
    }
    var firestoreService: FirestoreServiceProtocol {
        return rootComponent.firestoreService
    }
    var remoteConfigService: RemoteConfigServiceProtocol {
        return rootComponent.remoteConfigService
    }
    var userNotificationService: UserNotificationServiceProtocol {
        return rootComponent.userNotificationService
    }
    var toCollegeRouter: ToDestinationRouterProtocol {
        return rootComponent.toCollegeRouter
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->ToCollegeComponent
private func factoryd53809cef5d4c4c1e460b3a8f24c1d289f2c0f2e(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ToCollegeDependencya102e6c5eb750129b80aProvider(rootComponent: parent1(component) as! RootComponent)
}

#else
extension RootComponent: Registration {
    public func registerItems() {


    }
}
extension ToStationComponent: Registration {
    public func registerItems() {
        keyPathToName[\ToStationDependency.dateService] = "dateService-DateServiceProtocol"
        keyPathToName[\ToStationDependency.fileService] = "fileService-FileServiceProtocol"
        keyPathToName[\ToStationDependency.firestoreService] = "firestoreService-FirestoreServiceProtocol"
        keyPathToName[\ToStationDependency.remoteConfigService] = "remoteConfigService-RemoteConfigServiceProtocol"
        keyPathToName[\ToStationDependency.userNotificationService] = "userNotificationService-UserNotificationServiceProtocol"
        keyPathToName[\ToStationDependency.toStationRouter] = "toStationRouter-ToDestinationRouterProtocol"
    }
}
extension ToCollegeComponent: Registration {
    public func registerItems() {
        keyPathToName[\ToCollegeDependency.dateService] = "dateService-DateServiceProtocol"
        keyPathToName[\ToCollegeDependency.fileService] = "fileService-FileServiceProtocol"
        keyPathToName[\ToCollegeDependency.firestoreService] = "firestoreService-FirestoreServiceProtocol"
        keyPathToName[\ToCollegeDependency.remoteConfigService] = "remoteConfigService-RemoteConfigServiceProtocol"
        keyPathToName[\ToCollegeDependency.userNotificationService] = "userNotificationService-UserNotificationServiceProtocol"
        keyPathToName[\ToCollegeDependency.toCollegeRouter] = "toCollegeRouter-ToDestinationRouterProtocol"
    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@inline(never) private func register1() {
    registerProviderFactory("^->RootComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->RootComponent->ToStationComponent", factoryce11505cf466f1bc1658b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent->ToCollegeComponent", factoryd53809cef5d4c4c1e460b3a8f24c1d289f2c0f2e)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
