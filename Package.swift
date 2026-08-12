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
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.3/Primordial.xcframework.zip",
            checksum: "3c7cbd8fb1978674c94b0d304bd3824fd912027f623b8f926656273cf122f721"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.3/ObjectBox.xcframework.zip",
            checksum: "ceeda1ab66e7b8920b03cf3ea4163b50e0181e874fa3102f7a63ca4614fddd0d"
        )
    ]
)
