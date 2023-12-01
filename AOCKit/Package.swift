// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AOCKit",
    products: [
        .library(name: "AOCKit", targets: ["AOCKit"]),
    ],
    targets: [
        .target(name: "AOCKit"),
    ]
)
