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
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.9/Primordial.xcframework.zip",
            checksum: "12cb19bd719e7586639e4d4b9e575128bc14a50349213ec6d1334f61c3c4cb65"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.9/ObjectBox.xcframework.zip",
            checksum: "3494f8f6c99a9b12012324e260c552149a1a37ee06293c018f47a9490f6a68ab"
        )
    ]
)
