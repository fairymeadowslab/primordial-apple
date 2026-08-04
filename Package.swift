// swift-tools-version: 6.2

import PackageDescription

let package = Package(
    name: "Primordial",
    platforms: [
        .iOS(.v26),
        .macOS(.v26)
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
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.1/Primordial.xcframework.zip",
            checksum: "692b1f5a8cb2cd36f89d7b8baf25cd49f9de4f52cf23833399af0f4b5091ca1a"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.1/ObjectBox.xcframework.zip",
            checksum: "ceeda1ab66e7b8920b03cf3ea4163b50e0181e874fa3102f7a63ca4614fddd0d"
        )
    ]
)
