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
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.11/Primordial.xcframework.zip",
            checksum: "ca5e5f57db96dba57fab391b07f306dc209719e67e1ed55517b9d7d461685ca1"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.11/ObjectBox.xcframework.zip",
            checksum: "e326df64af11c964fcff096bc8d177070dc8f3b40aace8ba584c6682dfc862d4"
        )
    ]
)
