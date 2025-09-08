// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "OfflineAIAssistantDemo",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .executable(
            name: "OfflineAIAssistantDemo",
            targets: ["OfflineAIAssistantDemo"]
        ),
    ],
    dependencies: [
        // Add any external dependencies here if needed
    ],
    targets: [
        .executableTarget(
            name: "OfflineAIAssistantDemo",
            dependencies: [],
            path: "Demo"
        ),
    ]
)