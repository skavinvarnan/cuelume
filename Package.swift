// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Cuelume",
    platforms: [
        .iOS(.v18),
        .macOS(.v15),
        .tvOS(.v18),
        .visionOS(.v2),
    ],
    products: [
        .library(name: "Cuelume", targets: ["Cuelume"]),
    ],
    targets: [
        .target(
            name: "Cuelume",
            path: "Sources/Cuelume"
        ),
        .testTarget(
            name: "CuelumeTests",
            dependencies: ["Cuelume"],
            path: "Tests/CuelumeTests"
        ),
    ]
)
