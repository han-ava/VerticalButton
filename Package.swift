// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "VerticalButton",
    platforms: [.iOS(.v11)],
    products: [
        .library(name: "VerticalButton", targets: ["VerticalButton"]),
    ],
    targets: [
        .target(
            name: "VerticalButton",
            path: "Sources/VerticalButton"
        ),
        .testTarget(
            name: "VerticalButtonTests",
            dependencies: ["VerticalButton"],
            path: "Tests"
        )
    ]
)
