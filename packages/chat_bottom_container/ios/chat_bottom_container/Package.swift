// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to
// build this package.

import PackageDescription

let package = Package(
    name: "chat_bottom_container",
    platforms: [
        .iOS("13.0"),
    ],
    products: [
        .library(name: "chat-bottom-container", targets: ["chat_bottom_container"]),
    ],
    dependencies: [
        // Provided by the Flutter tool at build time (Flutter 3.44+). Gives the
        // plugin target access to the `Flutter` module.
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
    ],
    targets: [
        // Prebuilt native implementation, hosted as an xcframework on GitHub
        // Releases. Mirrors the `vendored_frameworks` used by the podspec so the
        // Swift Package Manager and CocoaPods builds stay in sync.
        .binaryTarget(
            name: "FSAChatBottomContainer",
            url: "https://github.com/LinXunFeng/flutter_chat_packages_pub/releases/download/chat_bottom_container/ios_0.0.1.zip",
            checksum: "b9c380b72010e5d378cc813fbc5cca9b21471b82134e633567a6beee4b5a2a91"
        ),
        .target(
            name: "chat_bottom_container",
            dependencies: [
                "FSAChatBottomContainer",
                .product(name: "FlutterFramework", package: "FlutterFramework"),
            ]
        ),
    ]
)
