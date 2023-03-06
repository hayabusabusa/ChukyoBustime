// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

private extension Target.Dependency {
    static let appFeature = Target.Dependency(stringLiteral: "AppFeature")
    static let firestore = Target.Dependency.product(name: "FirebaseFirestore", package: "firebase-ios-sdk")
    static let firestoreSwift = Target.Dependency.product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk")
    static let remoteConfig = Target.Dependency.product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk")
    static let remoteConfigSwift = Target.Dependency.product(name: "FirebaseRemoteConfigSwift", package: "firebase-ios-sdk")
    static let service = Target.Dependency(stringLiteral: "Service")
    static let serviceProtocol = Target.Dependency(stringLiteral: "ServiceProtocol")
    static let shared = Target.Dependency(stringLiteral: "Shared")
    static let swiftDate = Target.Dependency.product(name: "SwiftDate", package: "SwiftDate")
    static let toDestinationFeature = Target.Dependency(stringLiteral: "ToDestinationFeature")
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
    ],
    dependencies: [
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk.git",
            .upToNextMajor(from: "10.1.0")),
        .package(
            url: "https://github.com/malcommac/SwiftDate.git",
            .upToNextMajor(from: "7.0.0")),
    ],
    targets: [
        // MARK: Features
        .target(
            name: "AppFeature",
            dependencies: [
                .service,
                .toDestinationFeature,
            ],
            path: "./Sources/Feature/AppFeature"),
        .target(
            name: "ToDestinationFeature",
            dependencies: [
                .serviceProtocol,
                .shared,
            ],
            path: "./Sources/Feature/ToDestinationFeature"),

        // MARK: Core
        .target(
            name: "Service",
            dependencies: [
                .serviceProtocol,
                .firestore,
                .firestoreSwift,
                .remoteConfig,
                .remoteConfigSwift,
                .swiftDate,
            ]),
        .target(
            name: "ServiceProtocol",
            dependencies: []),
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
