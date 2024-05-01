// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Sqlite",
    products: [
        .library(
            name: "Sqlite",
            targets: ["Sqlite"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Sqlite",
            dependencies: ["SqliteWrapper"]
        ),
        .target(
            name: "SqliteWrapper",
            path: "Sources/SqliteWrapper",
            sources: ["include/SqliteWrapper.h", "src/SqliteWrapper.c"]
        ),
        .testTarget(
            name: "SqliteTests",
            dependencies: ["Sqlite"]
        ),
    ]
)

