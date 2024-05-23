// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import CompilerPluginSupport

let package = Package(
    name: "Examples",
    platforms: [
        .macOS(.v10_15), .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "DIContainer",
            targets: ["DIContainer"]
        ),
        .library(
            name: "Macros",
            targets: ["MacrosInterface"]
        ),
        .executable(
            name: "MacroPlayground",
            targets: ["MacrosPlayground"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0")
    ],
    targets: [
        .target(
            name: "DIContainer",
            dependencies: [],
            path: "Sources/Helpers/DIContainer"
        ),
        
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        // Macro implementation that performs the source transformation of a macro.
        .macro(
            name: "MacrosImplementation",
            dependencies: [
                .product(name: "SwiftSyntax", package: "swift-syntax"),
                .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
                .product(name: "SwiftCompilerPlugin", package: "swift-syntax"),
                .product(name: "SwiftDiagnostics", package: "swift-syntax"),
            ],
            path: "Sources/Macros/Implementation"
        ),

        // Library that exposes a macro as part of its API, which is used in client programs.
        .target(
            name: "MacrosInterface",
            dependencies: ["MacrosImplementation"],
            path: "Sources/Macros/Interface"
        ),

        // A client of the library, which is able to use the macro in its own code.
        .executableTarget(
            name: "MacrosPlayground",
            dependencies: [
                "DIContainer",
                "MacrosInterface"
            ],
            path: "Sources/Macros/Playground"
        ),

        // A test target used to develop the macro implementation.
        .testTarget(
            name: "MacrosImplmentationTest",
            dependencies: [
                "MacrosImplementation",
                .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax"),
            ],
            path: "Tests/Macros"
        ),
    ]
)
