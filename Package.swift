// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "swift-blurhash",
    platforms: [
        .macOS("13.3"), .iOS("16.4")
    ],
    products: [
        .library(
            name: "Blurhash",
            targets: ["Blurhash"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0"),
        //.package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.17.4")
    ],
    targets: [
        .target(
            name: "Blurhash",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms")
            ]
        ),
        .testTarget(
            name: "BlurhashTests",
            dependencies: [
                "Blurhash",
                //.product(name: "SnapshotTesting", package: "swift-snapshot-testing")
            ],
            resources: [.process("Resources")] // <- `copy` or `process` doesn't really matter
        ),
    ]
)
