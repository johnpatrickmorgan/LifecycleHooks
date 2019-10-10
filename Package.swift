// swift-tools-version:5.0
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "LifecycleHooks",
    platforms: [
        .iOS(.v8)
    ],
    products: [
        .library(
            name: "LifecycleHooks",
            targets: ["LifecycleHooks"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LifecycleHooks",
            dependencies: [],
            path: "Sources"
        )
    ]
)