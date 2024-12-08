// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private extension Target.Dependency {
    static let firestore = Target.Dependency.product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
    static let needle = Target.Dependency.product(name: "NeedleFoundation", package: "needle")
    static let remoteConfig = Target.Dependency.product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk")
    static let composableArchitecture = Target.Dependency.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    static let swiftDependencies = Target.Dependency.product(name: "Dependencies", package: "swift-dependencies")
    static let swiftDependenciesMacro = Target.Dependency.product(name: "DependenciesMacros", package: "swift-dependencies")
    static let swiftDate = Target.Dependency.product(name: "SwiftDate", package: "SwiftDate")
    static let appFeature = Target.Dependency(stringLiteral: "AppFeature")
    static let firestoreClient = Target.Dependency(stringLiteral: "FirestoreClient")
    static let toDestinationFeature = Target.Dependency(stringLiteral: "ToDestinationFeature")
    static let settingFeature = Target.Dependency(stringLiteral: "SettingFeature")
    static let service = Target.Dependency(stringLiteral: "Service")
    static let serviceProtocol = Target.Dependency(stringLiteral: "ServiceProtocol")
    static let shared = Target.Dependency(stringLiteral: "Shared")
}

let package = Package(
    name: "Package",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AppFeature",
            targets: [
                "AppFeature"
            ]),
        .library(
            name: "ToDestinationFeature",
            targets: [
                "ToDestinationFeature"
            ]),
        .library(
            name: "SettingFeature",
            targets: [
                "SettingFeature"
            ]),
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "11.6.0")),
        .package(
            url: "https://github.com/uber/needle.git",
            .upToNextMajor(from: "0.22.0")),
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            .upToNextMajor(from: "1.17.0")),
        .package(
            url: "https://github.com/pointfreeco/swift-dependencies",
            .upToNextMajor(from: "1.6.2")),
        .package(
            url: "https://github.com/malcommac/SwiftDate.git",
            .upToNextMajor(from: "7.0.0")),
    ],
    targets: [
        // MARK: Features
        .target(
            name: "AppFeature",
            dependencies: [
                .needle,
                .service,
                .settingFeature,
                .shared,
                .toDestinationFeature,
            ],
            path: "./Sources/Feature/AppFeature"),
        .target(
            name: "SettingFeature",
            dependencies: [
                .needle,
                .serviceProtocol,
                .shared,
            ],
            path: "./Sources/Feature/SettingFeature"),
        .target(
            name: "ToDestinationFeature",
            dependencies: [
                .needle,
                .serviceProtocol,
                .shared,
            ],
            path: "./Sources/Feature/ToDestinationFeature"),
        .target(
            name: "WidgetFeature",
            dependencies: [
                .serviceProtocol,
                .shared,
            ],
            path: "./Sources/Feature/WidgetFeature"),

        // MARK: Core
        .target(
            name: "Service",
            dependencies: [
                .firestore,
                .firestoreSwift,
                .remoteConfig,
                .remoteConfigSwift,
                .serviceProtocol,
                .shared,
                .swiftDate,
            ]),
        .target(
            name: "ServiceProtocol",
            dependencies: [
                .shared,
            ]),
        .target(
            name: "Shared",
            dependencies: []),

        // MARK: Tests
        .testTarget(
            name: "PackageTests",
            dependencies: [
                .service,
            ]),
    ]
)
