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
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.8/Primordial.xcframework.zip",
            checksum: "6d3b9940b9d0455e27f7b7efcf21d43607a09350470be3468e05fd231505b6d9"
        ),
        .binaryTarget(
            name: "ObjectBox",
            url: "https://github.com/fairymeadowslab/primordial-apple/releases/download/1.0.0-alpha.8/ObjectBox.xcframework.zip",
            checksum: "3494f8f6c99a9b12012324e260c552149a1a37ee06293c018f47a9490f6a68ab"
        )
    ]
)
