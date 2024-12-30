// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "AppFeature",
            targets: [
                "AppFeature"
            ]),
        .library(
            name: "DateClient",
            targets: [
                "DateClient"
            ]),
        .library(
            name: "DateClientLive",
            targets: [
                "DateClientLive"
            ]),
        .library(
            name: "FileClient",
            targets: [
                "FileClient"
            ]),
        .library(
            name: "FileClientLive",
            targets: [
                "FileClientLive"
            ]),
        .library(
            name: "FirebaseClient",
            targets: [
                "FirebaseClient"
            ]),
        .library(
            name: "FirebaseClientLive",
            targets: [
                "FirebaseClientLive"
            ]),
        .library(
            name: "FirestoreClient",
            targets: [
                "FirestoreClient"
            ]),
        .library(
            name: "FirestoreClientLive",
            targets: [
                "FirestoreClientLive"
            ]),
        .library(
            name: "RemoteConfigClient",
            targets: [
                "RemoteConfigClient"
            ]),
        .library(
            name: "RemoteConfigClientLive",
            targets: [
                "RemoteConfigClientLive"
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
        .library(
            name: "SharedView",
            targets: [
                "SharedView"
            ]),
        .library(
            name: "UserDefaultsClient",
            targets: [
                "UserDefaultsClient"
            ]),
        .library(
            name: "UserDefaultsClientLive",
            targets: [
                "UserDefaultsClientLive"
            ]),
        .library(
            name: "UserNotificationClient",
            targets: [
                "UserNotificationClient"
            ]),
        .library(
            name: "UserNotificationClientLive",
            targets: [
                "UserNotificationClientLive"
            ])
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "11.6.0")),
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
                "FirebaseClient",
                "Shared",
                "ToDestinationFeature",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]),
        .target(
            name: "SettingFeature",
            dependencies: [
                "Shared",
                "SharedView",
                "UserDefaultsClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]),
        .target(
            name: "ToDestinationFeature",
            dependencies: [
                "RemoteConfigClient",
                "SettingFeature",
                "Shared",
                "SharedView",
                "FirestoreClient",
                "UserNotificationClient",
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "SwiftDate", package: "SwiftDate"),
            ]),

        // MARK: Client
        .target(
            name: "DateClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]),
        .target(
            name: "DateClientLive",
            dependencies: [
                "DateClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
                .product(name: "SwiftDate", package: "SwiftDate"),
            ]),
        .target(
            name: "FileClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]),
        .target(
            name: "FileClientLive",
            dependencies: [
                "FileClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]),
        .target(
            name: "FirebaseClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]),
        .target(
            name: "FirebaseClientLive",
            dependencies: [
                "FirebaseClient",
                .product(name: "FirebaseAnalytics", package: "firebase-ios-sdk"),
                .product(name: "Dependencies", package: "swift-dependencies"),
            ]),
        .target(
            name: "FirestoreClient",
            dependencies: [
                "Shared",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]),
        .target(
            name: "FirestoreClientLive",
            dependencies: [
                "FirestoreClient",
                "Shared",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
            ]),
        .target(
            name: "RemoteConfigClient",
            dependencies: [
                "Shared",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]),
        .target(
            name: "RemoteConfigClientLive",
            dependencies: [
                "RemoteConfigClient",
                "Shared",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
            ]),
        .target(
            name: "Shared",
            dependencies: []),
        .target(
            name: "SharedView",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
            ]),
        .target(
            name: "UserDefaultsClient",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]),
        .target(
            name: "UserDefaultsClientLive",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                "UserDefaultsClient",
            ]),
        .target(
            name: "UserNotificationClient",
            dependencies: [
                "Shared",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies"),
            ]),
        .target(
            name: "UserNotificationClientLive",
            dependencies: [
                "Shared",
                "UserNotificationClient",
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "SwiftDate", package: "SwiftDate"),
            ]),

        // MARK: Tests
        .testTarget(
            name: "PackageTests",
            dependencies: []),
    ]
)
