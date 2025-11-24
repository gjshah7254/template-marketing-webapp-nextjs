// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ContentfulMarketing",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "ContentfulMarketing",
            targets: ["ContentfulMarketing"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/contentful/contentful.swift", from: "5.0.0"),
        .package(url: "https://github.com/contentful/rich-text-renderer.swift", from: "1.0.0"),
        .package(url: "https://github.com/onevcat/Kingfisher", from: "7.0.0"),
    ],
    targets: [
        .target(
            name: "ContentfulMarketing",
            dependencies: [
                .product(name: "Contentful", package: "contentful.swift"),
                .product(name: "ContentfulRichTextRenderer", package: "rich-text-renderer.swift"),
                .product(name: "Kingfisher", package: "Kingfisher"),
            ]
        ),
    ]
)

