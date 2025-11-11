// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PPUIComponetCore",
    platforms: [
        .macOS(.v15),   // ✅ 推荐写 macOS 12 或更高
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PPUIComponetCore",
            targets: ["PPUIComponetCore"]),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PPUIComponetCore"),
        .testTarget(
            name: "PPUIComponetCoreTests",
            dependencies: ["PPUIComponetCore"]
        ),
    ]
)
