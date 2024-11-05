// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "LoggingSDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "LoggingSDK",
            targets: ["LoggingSDK"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/Alamofire/Alamofire.git", from: "5.0.0"),
        .package(name: "Firebase", url: "https://github.com/firebase/firebase-ios-sdk.git", from: "8.0.0")
    ],
    targets: [
        .target(
            name: "LoggingSDK",
            dependencies: ["Alamofire", .product(name: "FirebaseAnalytics", package: "Firebase")],
            path: "Sources/LoggingSDK",
            exclude: ["Tests"]
        ),
        .testTarget(
            name: "LoggingSDKTests",
            dependencies: ["LoggingSDK"],
            path: "Tests/LoggingSDKTests"
        ),
    ]
)
