// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AOCKit",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "AOCKit", targets: ["AOCKit"]),
    ],
    targets: [
        .target(name: "AOCKit"),
    ]
)
