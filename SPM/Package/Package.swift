// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Package",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "AppFeature",
            targets: ["AppFeature"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "AppFeature",
            dependencies: [
                "Service",
            ]),
        .target(
            name: "Service",
            dependencies: []),
        .testTarget(
            name: "PackageTests",
            dependencies: [
                "Service"
            ]),
    ]
)
