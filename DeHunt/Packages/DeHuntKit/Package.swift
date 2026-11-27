// swift-tools-version: 6.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "DeHuntKit",
    platforms: [
        .iOS(.v26)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Networking",
            targets: ["Networking"]
        ),
        .library(
            name: "DefiLlama",
            targets: ["DefiLlama"]
        ),
        .library(
            name: "Watchlist",
            targets: ["Watchlist"]
        ),
        .library(
            name: "Design",
            targets: ["Design"]
        ),
        .library(
            name: "Dashboard",
            targets: ["Dashboard"]
        ),
        .library(
            name: "Strategies",
            targets: ["Strategies"]
        ),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Networking",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency"),
            ],
        ),
        .target(
            name: "DefiLlama",
            dependencies: ["Networking"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        ),
        .target(
            name: "Watchlist",
            dependencies: ["DefiLlama"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        ),
        .target(
            name: "Design",
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        ),
        .target(
            name: "Dashboard",
            dependencies: ["Design", "Networking", "DefiLlama"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        ),
        .target(
            name: "Strategies",
            dependencies: ["Design", "DefiLlama", "Watchlist"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        ),
        .target(
            name: "DefiLlamaTestSupport",
            dependencies: ["DefiLlama"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        ),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        ),
        .testTarget(
            name: "DefiLlamaTests",
            dependencies: ["Networking", "DefiLlama"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        ),
        .testTarget(
            name: "WatchlistTests",
            dependencies: ["DefiLlamaTestSupport", "Watchlist", "DefiLlama"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        ),
        .testTarget(
            name: "DashboardTests",
            dependencies: ["DefiLlamaTestSupport", "Dashboard", "DefiLlama", "Networking"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        ),
        .testTarget(
            name: "StrategiesTests",
            dependencies: ["DefiLlamaTestSupport", "Strategies", "Watchlist", "DefiLlama", "Networking"],
            swiftSettings: [
                .enableUpcomingFeature("ApproachableConcurrency")
            ]
        ),
    ]
)
