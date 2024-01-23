// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

/// The main pacakge for vector and matrix routines used in many places.
///
/// This package is where I put all the underlying matrix algebra materials for popgen and spatial data work. 




let package = Package(
    name: "DLMatrix",
    platforms: [ .macOS("14"),
                 .iOS(.v16)
               ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "DLMatrix",
            targets: ["DLMatrix"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        // .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0"),

    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "DLMatrix",
            dependencies: [],
            swiftSettings: [
                .define("ACCELERATE_NEW_LAPACK")
            ]),
        .testTarget(
            name: "DLMatrixTests",
            dependencies: ["DLMatrix"] ),
    ]
)
