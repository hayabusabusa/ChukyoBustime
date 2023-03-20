

import NeedleFoundation
import Service
import ServiceProtocol
import SettingFeature
import Shared
import ToDestinationFeature
import UIKit

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

private func parent2(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class SettingDependencyeb81f4a491e62d25bd63Provider: SettingDependency {
    var userDefaultsService: UserDefaultsServiceProtocol {
        return rootComponent.userDefaultsService
    }
    private let rootComponent: RootComponent
    init(rootComponent: RootComponent) {
        self.rootComponent = rootComponent
    }
}
/// ^->RootComponent->ToStationComponent->SettingComponent
private func factory665ba82bdea0118a4246a9403e3301bb54f80df0(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SettingDependencyeb81f4a491e62d25bd63Provider(rootComponent: parent2(component) as! RootComponent)
}
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
extension SettingComponent: Registration {
    public func registerItems() {
        keyPathToName[\SettingDependency.userDefaultsService] = "userDefaultsService-UserDefaultsServiceProtocol"
    }
}
extension ToStationComponent: Registration {
    public func registerItems() {
        keyPathToName[\ToStationDependency.dateService] = "dateService-DateServiceProtocol"
        keyPathToName[\ToStationDependency.fileService] = "fileService-FileServiceProtocol"
        keyPathToName[\ToStationDependency.firestoreService] = "firestoreService-FirestoreServiceProtocol"
        keyPathToName[\ToStationDependency.remoteConfigService] = "remoteConfigService-RemoteConfigServiceProtocol"
        keyPathToName[\ToStationDependency.userNotificationService] = "userNotificationService-UserNotificationServiceProtocol"

    }
}
extension RootComponent: Registration {
    public func registerItems() {


    }
}
extension ToCollegeComponent: Registration {
    public func registerItems() {
        keyPathToName[\ToCollegeDependency.dateService] = "dateService-DateServiceProtocol"
        keyPathToName[\ToCollegeDependency.fileService] = "fileService-FileServiceProtocol"
        keyPathToName[\ToCollegeDependency.firestoreService] = "firestoreService-FirestoreServiceProtocol"
        keyPathToName[\ToCollegeDependency.remoteConfigService] = "remoteConfigService-RemoteConfigServiceProtocol"
        keyPathToName[\ToCollegeDependency.userNotificationService] = "userNotificationService-UserNotificationServiceProtocol"

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
    registerProviderFactory("^->RootComponent->ToStationComponent->SettingComponent", factory665ba82bdea0118a4246a9403e3301bb54f80df0)
    registerProviderFactory("^->RootComponent->ToCollegeComponent->SettingComponent", factory665ba82bdea0118a4246a9403e3301bb54f80df0)
    registerProviderFactory("^->RootComponent->ToStationComponent", factoryce11505cf466f1bc1658b3a8f24c1d289f2c0f2e)
    registerProviderFactory("^->RootComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->RootComponent->ToCollegeComponent", factoryd53809cef5d4c4c1e460b3a8f24c1d289f2c0f2e)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
