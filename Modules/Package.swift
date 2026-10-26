// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "NSScreencastModules",
    platforms: [
        .macOS(.v27),
        .iOS(.v27)
    ],
    products: [
        .library(name: "APIClient", targets: ["APIClient"]),
        .library(name: "Database", targets: ["Database"]),
    ],
    dependencies: [
      .package(url: "https://github.com/pointfreeco/sqlite-data", from: "1.12.1")
    ],
    targets: [
        .target(
            name: "APIClient",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "APIClientTests",
            dependencies: ["APIClient"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .target(
            name: "Database",
            dependencies: [.product(name: "SQLiteData", package: "sqlite-data")],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .testTarget(
            name: "DatabaseTests",
            dependencies: ["Database"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
    ]
)
