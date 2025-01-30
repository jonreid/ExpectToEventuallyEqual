// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "ExpectToEventuallyEqual",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .watchOS(.v6),
        .tvOS(.v13)
    ],
    products: [
        .library(
            name: "ExpectToEventuallyEqual",
            targets: ["ExpectToEventuallyEqual"]),
    ],
    targets: [
        .target(
            name: "ExpectToEventuallyEqual"),
        .testTarget(
            name: "ExpectToEventuallyEqualTests",
            dependencies: ["ExpectToEventuallyEqual"]),
    ]
)
