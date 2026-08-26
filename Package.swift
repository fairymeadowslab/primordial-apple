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
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.7/Primordial.xcframework.zip",
            checksum: "8694c41e2345fa87abebd2cc736c01a5d3ef9f971bcc99510ed47a955b67687f"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.7/ObjectBox.xcframework.zip",
            checksum: "ebd67dc1eea389e9cf62507a7c80f1da713381933fdc6781f23dbb4b7791bdd8"
        )
    ]
)
