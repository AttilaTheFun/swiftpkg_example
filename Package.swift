// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Packages",
    dependencies: [
        .package(url: "https://github.com/onevcat/Kingfisher", .upToNextMajor(from: "7.6.2")),
        .package(url: "https://github.com/devicekit/DeviceKit", .upToNextMajor(from: "4.1.0")),
    ]
)
