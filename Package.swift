// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "ScreenMacros",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .tvOS(.v17),
        .watchOS(.v10),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "ScreenMacros",
            targets: ["ScreenMacros"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/swiftlang/swift-syntax.git", from: "602.0.0"),
    ],
    targets: [
        // Core library containing macro implementations (importable for testing)
        .target(
            name: "ScreenMacrosCore",
            dependencies: [
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
            ],
            path: "Sources/ScreenMacrosCore"
        ),
        // Compiler plugin that wraps the core implementation
        .macro(
            name: "ScreenMacrosImpl",
            dependencies: [
                "ScreenMacrosCore",
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
            ],
            path: "Sources/ScreenMacrosPlugin"
        ),
        .target(
            name: "ScreenMacros",
            dependencies: ["ScreenMacrosImpl"],
            path: "Sources/ScreenMacrosClient"
        ),
        .testTarget(
            name: "ScreenMacrosTests",
            dependencies: [
                "ScreenMacrosCore",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ]
        ),
    ]
)
