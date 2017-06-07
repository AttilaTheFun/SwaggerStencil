// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "SwaggerStencil",
    dependencies: [
        .Package(url: "https://github.com/kylef/Stencil.git", majorVersion: 0),
        .Package(url: "https://www.github.com/AttilaTheFun/SwaggerParser.git", majorVersion: 0)
    ]
)
