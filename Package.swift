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
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.2/Primordial.xcframework.zip",
            checksum: "b6ca85f1a8337829f07bb4d11af4690272b10d525f540eee9d1442db9d068edc"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.2/ObjectBox.xcframework.zip",
            checksum: "ceeda1ab66e7b8920b03cf3ea4163b50e0181e874fa3102f7a63ca4614fddd0d"
        )
    ]
)
