// swift-tools-version: 5.7

import PackageDescription

let package = Package(
    name: "Petungan",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6),
    ],
    products: [
        .library(name: "Petungan", targets: ["Petungan"]),
    ],
    targets: [
        .target(name: "Petungan"),
        .testTarget(name: "PetunganTests", dependencies: ["Petungan"]),
    ]
)
