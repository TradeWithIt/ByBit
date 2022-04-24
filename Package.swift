// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ByBit",
    platforms: [
        .macOS(.v12), .iOS(.v15), .tvOS(.v15), .watchOS(.v8)
    ],
    products: [
        .library(
            name: "ByBit",
            targets: ["ByBit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/TradeWithIt/API", branch: "main"),
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift.git", from: "1.5.0"),
    ],
    targets: [
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
