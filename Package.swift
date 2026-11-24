// swift-tools-version: 6.3

import PackageDescription

let package = Package(
    name: "Primordial",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "Primordial",
            targets: ["Primordial", "ObjectBox"]
        )
    ],
    targets: [
        .binaryTarget(
            name: "Primordial",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.15/Primordial.xcframework.zip",
            checksum: "e30f44d45f2aaf3edffddeb3b2f78fc8512f3efe882ebb0d5fc36f04e27669ad"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.15/ObjectBox.xcframework.zip",
            checksum: "e326df64af11c964fcff096bc8d177070dc8f3b40aace8ba584c6682dfc862d4"
        )
    ]
)
