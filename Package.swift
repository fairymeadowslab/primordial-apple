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
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.6/Primordial.xcframework.zip",
            checksum: "1f3db1449e45ea78f01d60d91caecf667cad4de46259ef1e04655fb0f0669881"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.6/ObjectBox.xcframework.zip",
            checksum: "b0e93b85c58392052b60d29d062e637c7c1eb49fe566d4d541de15dc20c4d01b"
        )
    ]
)
