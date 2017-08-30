// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "SwaggerStencil",
    dependencies: [
        .Package(url: "https://github.com/behrang/YamlSwift.git", majorVersion: 3),
        .Package(url: "https://github.com/SwiftGen/StencilSwiftKit.git", majorVersion: 2),
        .Package(url: "https://github.com/AttilaTheFun/SwaggerParser.git", majorVersion: 0, minor: 5)
    ]
)
