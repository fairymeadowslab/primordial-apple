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
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.10/Primordial.xcframework.zip",
            checksum: "826540bef3ecf5b845fda3919a9b9901b068675571c674cac1510e9129fa6e64"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.10/ObjectBox.xcframework.zip",
            checksum: "e326df64af11c964fcff096bc8d177070dc8f3b40aace8ba584c6682dfc862d4"
        )
    ]
)
