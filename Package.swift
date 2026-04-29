// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "AiStatus",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "AiStatus", targets: ["AiStatus"])
    ],
    targets: [
        .target(name: "CodexStatusCore"),
        .executableTarget(
            name: "AiStatus",
            dependencies: ["CodexStatusCore"]
        ),
        .testTarget(
            name: "CodexStatusCoreTests",
            dependencies: ["CodexStatusCore"]
        )
    ]
)
