// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "PersistentValue",
  platforms: [.iOS(.v13)],
  products: [
    .library(
      name: "PersistentValue",
      targets: ["PersistentValue"])
  ],
  dependencies: [],
  targets: [
    .target(
      name: "PersistentValue",
      dependencies: [],
      path: "Sources"
    )
  ]
)
