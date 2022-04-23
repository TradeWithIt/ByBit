// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ByBit",
    platforms: [
      .macOS(.v12), .iOS(.v13), .tvOS(.v13), .watchOS(.v6)
    ],
    products: [
        .library(
            name: "ByBit",
            targets: ["ByBit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/TradeWithIt/API", from: "1.0.0"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.5.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "ByBit",
            dependencies: [
                .product(name: "API", package: "API"),
                .product(name: "CryptoSwift", package: "CryptoSwift"),
            ]),
        .testTarget(
            name: "ByBitTests",
            dependencies: ["ByBit"]),
    ]
)
