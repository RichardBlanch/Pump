// swift-tools-version:4.0
import PackageDescription
let package = Package(
    name: "Pump",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git",
                 from: "3.0.0-rc"),
        // 1
        .package(url: "https://github.com/vapor/fluent-mysql.git",
                 from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor-community/pagination.git", from: "1.0.0"),
        .package(url: "https://github.com/RichardBlanch/PumpModels.git", from: "0.2.9"),
        .package(url: "https://github.com/vapor/leaf.git", from: "3.0.0-rc"),
        .package(url: "https://github.com/vapor/auth.git", from: "2.0.0-rc")
        ], targets: [
            // 2
            .target(name: "App", dependencies: ["FluentMySQL",
                                                "Leaf",
                                                "Authentication",
                                                "Pagination",
                                                "PumpModels",
                                                "Vapor"]),
            .target(name: "Run", dependencies: ["App"]),
            .testTarget(name: "AppTests", dependencies: ["App"]),
            ]
)
