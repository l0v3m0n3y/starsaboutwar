// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "starsaboutwar",
    platforms: [
        .macOS(.v12), .iOS(.v15)
    ],
    products: [
        .library(name: "starsaboutwar", targets: ["starsaboutwar"]),
    ],
    targets: [
        .target(
            name: "starsaboutwar",
            path: "src"
        ),
    ]
)
