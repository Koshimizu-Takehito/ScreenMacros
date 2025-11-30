# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.4] - 2025-11-30

### Changed

- Unlabeled associated values are now passed to View initializers without labels by default
  - `case preview(Int)` now generates `Preview(param0)` instead of `Preview(param0: param0)`
  - This allows seamless integration with Views that have unlabeled initializer parameters (e.g., `init(_ id: Int)`)
  - Use mapping `@Screen(["param0": "id"])` to add a label if needed

### Added

- Example: Added `Preview` view demonstrating unlabeled parameter handling
- Documentation: Added "Unlabeled Associated Values" section to README and GettingStarted

## [1.0.3] - 2025-11-30

### Added

- CI/CD workflow with GitHub Actions (build, test, lint, format check)
- SwiftLint and SwiftFormat integration via Mint
- Makefile for local development commands
- DocC documentation catalog for Swift Package Index hosting
- `.spi.yml` configuration for Swift Package Index documentation

### Changed

- Updated CI environment to macOS 15 with Xcode 16.1

## [1.0.2] - 2025-11-29

### Added

- DeepWiki badge to README for AI-powered documentation assistance

## [1.0.1] - 2025-11-29

### Added

- Example iOS app demonstrating all ScreenMacros features

### Changed

- Replace static badges with dynamic Swift Package Index badges in README
- Rename `ScreenID` to `Screen` in documentation examples for clarity

## [1.0.0] - 2024-11-29

### Added

- `@Screens` macro for automatic `View` and `Screens` protocol conformance
- `@Screen` macro for explicit View type specification
- Associated values support with automatic parameter binding
- Parameter mapping for renaming case labels to View initializer parameters
- Generics and module-qualified type support
- Access level auto-adjustment (public/internal/fileprivate/private)
- Unused mapping key warnings
- SwiftUI navigation helpers:
  - `navigationDestination(_:)` for NavigationStack
  - `sheet(item:)` for modal presentation
  - `fullScreenCover(item:)` for full-screen presentation (iOS/tvOS/watchOS/visionOS)
- ForEach helpers:
  - `ScreensForEach` for custom content iteration
  - `ScreensForEachView` for direct View rendering

### Requirements

- Swift 6.0+
- iOS 17.0+ / macOS 14.0+

[Unreleased]: https://github.com/Koshimizu-Takehito/ScreenMacros/compare/v1.0.4...HEAD
[1.0.4]: https://github.com/Koshimizu-Takehito/ScreenMacros/compare/v1.0.3...v1.0.4
[1.0.3]: https://github.com/Koshimizu-Takehito/ScreenMacros/compare/v1.0.2...v1.0.3
[1.0.2]: https://github.com/Koshimizu-Takehito/ScreenMacros/compare/v1.0.1...v1.0.2
[1.0.1]: https://github.com/Koshimizu-Takehito/ScreenMacros/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/Koshimizu-Takehito/ScreenMacros/releases/tag/v1.0.0
