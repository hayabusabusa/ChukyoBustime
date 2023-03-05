// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    platforms: [.iOS(.v14)],
    products: [
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
        .library(
            name: "Preview",
            targets: [
                "BusListView",
                "CountdownView",
                "DiagramView",
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
                "Service",
            ],
            path: "./Sources/Feature/AppFeature"),
        .target(name: "ToDestinationFeature",
                dependencies: [
                    "Service",
                    "BusListView",
                    "CountdownView",
                    "DiagramView",
                ],
                path: "./Sources/Feature/ToDestinationFeature"),

        // MARK: View
        .target(name: "BusListView",
                dependencies: [
                    "Shared",
                ],
                path: "./Sources/View/BusListView"),
        .target(name: "CountdownView",
                dependencies: [
                    "Shared",
                ],
                path: "./Sources/View/CountdownView"),
        .target(name: "DiagramView",
                dependencies: [],
                path: "./Sources/View/DiagramView"),

        // MARK: Core
        .target(
            name: "Service",
            dependencies: [
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
                .product(name: "FirebaseRemoteConfigSwift", package: "firebase-ios-sdk"),
                .product(name: "SwiftDate", package: "SwiftDate"),
            ]),
        .target(
            name: "Shared",
            dependencies: []),

        // MARK: Tests
        .testTarget(
            name: "PackageTests",
            dependencies: [
                "Service"
            ]),
    ]
)
