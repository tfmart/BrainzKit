// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "BrainzKit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12),
        .macCatalyst(.v15),
        .watchOS(.v8),
        .tvOS(.v15),
        .visionOS(.v1)
    ],
    products: [
        .library(
            name: "BrainzKit",
            targets: ["BrainzKit"]
        )
    ],
    targets: [
        .target(name: "BrainzKit"),
        .testTarget(
            name: "BrainzKitTests",
            dependencies: ["BrainzKit"]
        )
    ]
)
