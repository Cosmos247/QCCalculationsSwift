// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "QCCalculationsSwift",
    products: [
        .library(
            name: "QCCalculationsSwift",
            targets: ["QCCalculationsSwift"])
    ],
    targets: [
        .target(
            name: "QCCalculationsSwift")
    ]
)
