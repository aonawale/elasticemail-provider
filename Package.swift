import PackageDescription

let package = Package(
    name: "ElasticEmailProvider",
    dependencies: [
        .Package(url: "https://github.com/vapor/vapor.git", majorVersion: 2)
    ]
)

