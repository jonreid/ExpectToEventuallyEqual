// swift-tools-version: 5.6

import PackageDescription

let package = Package(
    name: "ExpectToEventuallyEqual",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .tvOS(.v15),
        .watchOS(.v8),
    ],
    products: [
        .library(
            name: "ExpectToEventuallyEqual",
            targets: ["ExpectToEventuallyEqual"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jonreid/FailKit.git", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "ExpectToEventuallyEqual",
            dependencies: ["FailKit"]),
        .testTarget(
            name: "ExpectToEventuallyEqualTests",
            dependencies: ["ExpectToEventuallyEqual"]),
    ]
)
