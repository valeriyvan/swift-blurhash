// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "swift-blurshash",
    products: [
        .library(
            name: "swift-blurshash",
            targets: ["swift-blurshash"]),
    ],
    targets: [
        .target(
            name: "swift-blurshash"),
        .testTarget(
            name: "swift-blurshashTests",
            dependencies: ["swift-blurshash"]
        ),
    ]
)
