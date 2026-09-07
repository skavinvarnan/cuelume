// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Cuelume",
    platforms: [
        .iOS(.v26),
        .macOS(.v26),
        .tvOS(.v26),
        .visionOS(.v26),
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
