// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "OfflineAIAssistant",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "OfflineAIAssistant",
            targets: ["OfflineAIAssistant"]
        ),
    ],
    dependencies: [
        // Add any external dependencies here if needed
    ],
    targets: [
        .target(
            name: "OfflineAIAssistant",
            dependencies: [],
            path: "Sources"
        ),
    ]
)