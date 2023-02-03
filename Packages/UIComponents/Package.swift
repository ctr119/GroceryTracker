// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "UIComponents",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "UIComponents",
            targets: ["UIComponents"]),
    ],
    dependencies: [
        
    ],
    targets: [
        .target(
            name: "UIComponents",
            dependencies: []),
        .testTarget(
            name: "UIComponentsTests",
            dependencies: ["UIComponents"]),
    ]
)
