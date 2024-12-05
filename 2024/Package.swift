// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AOC2024",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(name: "AOCKit", path: "../AOCKit"),
        .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.0.0")),
        .package(url: "https://github.com/apple/swift-collections.git", .upToNextMajor(from: "1.0.0"))
    ], 
    targets: [
        .executableTarget(
            name: "AOC2024",
            dependencies: [
                .product(name: "AOCKit", package: "AOCKit"),
                .product(name: "Algorithms", package: "swift-algorithms"),
                .product(name: "Collections", package: "swift-collections")
            ],
            resources: [
                .process("Inputs")
            ]
        ),
    ]
)
