// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "Swift6502",
    products: [
        .library(
            name: "Swift6502",
            targets: ["Swift6502"]
        ),
    ],
    targets: [
        .target(
            name: "Swift6502"
        ),
        .testTarget(
            name: "Swift6502Tests",
            dependencies: ["Swift6502"]
        ),
    ]
)
