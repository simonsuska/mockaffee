// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Mockaffee",
    products: [
        .library(
            name: "Mockaffee",
            targets: ["Mockaffee"]),
    ],
    targets: [
        .target(
            name: "Mockaffee"),
        .testTarget(
            name: "MockaffeeTests",
            dependencies: ["Mockaffee"]),
    ]
)
