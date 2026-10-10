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
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.13/Primordial.xcframework.zip",
            checksum: "5067924b102d8cd9d205bf96fcb111c500bfaf0ec49a8eda1825a9f16c4df90e"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.13/ObjectBox.xcframework.zip",
            checksum: "e326df64af11c964fcff096bc8d177070dc8f3b40aace8ba584c6682dfc862d4"
        )
    ]
)
