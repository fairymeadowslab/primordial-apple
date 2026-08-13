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
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.4/Primordial.xcframework.zip",
            checksum: "2e896f180ff8d822141a09be3b106373946b7348e0cecbfe3adbff0ecb84d2ae"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.4/ObjectBox.xcframework.zip",
            checksum: "ceeda1ab66e7b8920b03cf3ea4163b50e0181e874fa3102f7a63ca4614fddd0d"
        )
    ]
)
