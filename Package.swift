// swift-tools-version: 5.6
import PackageDescription

let package = Package(
    name: "Cacao",
    products: [
        .library(name: "Cacao", targets: ["Cacao"]),
        .executable(name: "CacaoDemo", targets: ["CacaoDemo"]),
        ],
    dependencies: [
        .package(
            url: "https://github.com/austintatiousness/Silica.git",
            .branch("master")
        ),
        .package(
            url: "https://github.com/austintatiousness/Cairo.git",
            .branch("master")
        ),
        .package(
            url: "https://github.com/austintatiousness/SDL.git",
            .branch("master")
        )
    ],
    targets: [
        .target(
            name: "Cacao",
            dependencies: [
                "Silica",
                "Cairo",
                "SDL"
            ]
        ),
        .executableTarget(
            name: "CacaoDemo",
            dependencies: [
                "Cacao"
            ]
        ),
        ]
)
