// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SweetCurtain",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "SweetCurtain",
            targets: ["SweetCurtain"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SweetCurtain",
            dependencies: []),
        .testTarget(
            name: "SweetCurtainTests",
            dependencies: ["SweetCurtain"]),
    ]
)
