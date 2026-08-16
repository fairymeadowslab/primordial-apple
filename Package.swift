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
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.5/Primordial.xcframework.zip",
            checksum: "9590e5407861f150c5c9d533d8d0b41d77de462266770e3222db3d1e2e962948"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.5/ObjectBox.xcframework.zip",
            checksum: "ceeda1ab66e7b8920b03cf3ea4163b50e0181e874fa3102f7a63ca4614fddd0d"
        )
    ]
)
