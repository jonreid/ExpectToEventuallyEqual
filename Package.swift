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
    dependencies: [
        .package(url: "https://github.com/jonreid/FailKit.git", branch: "main")
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
