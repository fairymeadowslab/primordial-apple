// swift-tools-version: 6.2

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
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.12/Primordial.xcframework.zip",
            checksum: "93fbfd43e1f39fa6a7f5cca94693d59e769dd5f14b6446ceedc3d3ec6e25c541"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.12/ObjectBox.xcframework.zip",
            checksum: "e326df64af11c964fcff096bc8d177070dc8f3b40aace8ba584c6682dfc862d4"
        )
    ]
)
