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
        .package(url: "https://github.com/RichardBlanch/Models.git",
                 from: "1.0.0"),
        ], targets: [
            // 2
            .target(name: "App", dependencies: ["FluentMySQL",
                                                "Vapor",
                                                "Models"]),
            .target(name: "Run", dependencies: ["App"]),
            .testTarget(name: "AppTests", dependencies: ["App"]),
            ]
)
