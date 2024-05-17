// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "TaskManagerPackage",
  platforms: [
    .iOS(.v16),
    .macOS(.v14),
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "AppFeature",
      targets: ["AppFeature"]),
    .library(name: "Model", targets: ["Model"]),
    .library(name: "SidebarFeature", targets: ["SidebarFeature"]),
    .library(name: "TaskFeature", targets: ["TaskFeature"]),
    .library(name: "TaskListFeature", targets: ["TaskListFeature"]),
  ],
  dependencies: [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.10.1"),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "AppFeature",
      dependencies: [
        .Model,
        .SCA,
        .TaskListFeature,
        .SidebarFeature,
      ]
    ),
    .target(
      name: "Model",
      dependencies: [
      ]
    ),
    .target(
      name: "SidebarFeature",
      dependencies: [
        .Model,
        .SCA,
      ]
    ),
    .target(
      name: "TaskFeature",
      dependencies: [
        .Model,
        .SCA,
      ]
    ),
    .target(
      name: "TaskListFeature",
      dependencies: [
        .TaskFeature,
        .Model,
        .SCA,
      ]
    ),
    .testTarget(
      name: "TaskManagerPackageTests",
      dependencies: ["AppFeature"]),
  ]
)

extension Target.Dependency {
  static let Model = Target.Dependency(stringLiteral: "Model")
  static let TaskFeature = Target.Dependency(stringLiteral: "TaskFeature")
  static let TaskListFeature = Target.Dependency(stringLiteral: "TaskListFeature")
  static let SidebarFeature = Target.Dependency(stringLiteral: "SidebarFeature")
  static let SCA = Target.Dependency.product(name: "ComposableArchitecture", package: "swift-composable-architecture")
}
