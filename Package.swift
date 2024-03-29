// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CommonPackage",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "CommonPackage",
            targets: ["CommonPackage"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        .package(url: "https://github.com/malcommac/SwiftDate.git", from: "7.0.0"),
        .package(url: "https://github.com/hackiftekhar/IQKeyboardManager.git", from: "6.5.0"),
        .package(url: "https://github.com/DaveWoodCom/XCGLogger.git", from: "7.0.1"),
        .package(url: "https://github.com/ninjaprox/NVActivityIndicatorView.git", from: "5.1.1"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess.git", from: "4.2.2"),
        .package(url: "https://github.com/SnapKit/SnapKit.git", from: "5.6.0"),
        .package(url: "https://github.com/ReactiveX/RxSwift.git", from: "6.6.0"),
        .package(url: "https://github.com/eddiekaiger/SwiftyAttributes.git", from: "5.3.0"),
        .package(url: "https://github.com/RxSwiftCommunity/RxGesture.git", from: "4.0.4"),
        .package(url: "https://github.com/Juanpe/SkeletonView.git", from: "1.30.4"),
        .package(url: "https://github.com/RxSwiftCommunity/RxSwiftExt.git", from: "6.2.0"),
        .package(url: "https://github.com/evgenyneu/Cosmos.git", branch: "master"),
        .package(url: "https://github.com/google/GoogleSignIn-iOS", from: "7.0.0"),
        .package(url: "https://github.com/facebook/facebook-ios-sdk", from: "16.1.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "CommonPackage",
            dependencies: [
                .product(name: "SwiftDate", package: "SwiftDate"),
                .product(name: "IQKeyboardManagerSwift", package: "IQKeyboardManager"),
                .product(name: "XCGLogger", package: "XCGLogger"),
                .product(name: "NVActivityIndicatorView", package: "NVActivityIndicatorView"),
                .product(name: "KeychainAccess", package: "KeychainAccess"),
                .product(name: "SnapKit", package: "SnapKit"),
                .product(name: "RxSwift", package: "RxSwift"),
                .product(name: "RxCocoa", package: "RxSwift"),
                .product(name: "SwiftyAttributes", package: "SwiftyAttributes"),
                .product(name: "RxGesture", package: "RxGesture"),
                .product(name: "SkeletonView", package: "SkeletonView"),
                .product(name: "RxSwiftExt", package: "RxSwiftExt"),
                .product(name: "Cosmos", package: "Cosmos"),
                .product(name: "GoogleSignIn", package: "GoogleSignIn-iOS"),
                .product(name: "FacebookCore", package: "facebook-ios-sdk"),
                .product(name: "FacebookLogin", package: "facebook-ios-sdk")
            ]),
        .testTarget(
            name: "CommonPackageTests",
            dependencies: ["CommonPackage"]),
    ]
)
