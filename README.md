# ScreenMacros

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platforms-iOS%2017+%20|%20macOS%2014+-blue.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**ScreenMacros** is a Swift macro package that generates type-safe SwiftUI views from enums.

```swift
@Screens
enum ScreenID {
    case home
    case detail(id: Int)
}
```

After macro expansion:

```swift
extension ScreenID: View, ScreenMacros.Screens {
    @MainActor @ViewBuilder
    var body: some View {
        switch self {
        case .home:
            Home()
        case .detail(id: let id):
            Detail(id: id)
        }
    }
}
```

You can now use `ScreenID` directly as a SwiftUI `View`.

## Features

- 🎯 Type-safe screen-to-view mapping
- 🔄 Automatic View protocol conformance
- 📦 Associated values support
- 🗺️ Parameter mapping
- 🧩 SwiftUI navigation helpers

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Macros](#macros)
- [Parameter Mapping](#parameter-mapping)
- [Access Control](#access-control)
- [Associated Values](#associated-values)
- [Navigation Helpers](#navigation-helpers)
- [ForEach Helpers](#foreach-helpers)
- [License](#license)

## Requirements

- Swift 6.0+
- iOS 17.0+ / macOS 14.0+ / tvOS 17.0+ / watchOS 10.0+ / visionOS 1.0+

---

## Installation

### Swift Package Manager

Add **ScreenMacros** as a dependency in your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/Koshimizu-Takehito/ScreenMacros.git", from: "1.0.0")
]
```

Then add it to your target:

```swift
.target(
    name: "YourFeature",
    dependencies: [
        .product(name: "ScreenMacros", package: "ScreenMacros")
    ]
)
```

### Xcode

1. File → Add Package Dependencies...
2. Enter: `https://github.com/Koshimizu-Takehito/ScreenMacros.git`
3. Select version: `1.0.0` or later

---

## Macros

### `@Screens`

- **Attached to**: enum
- **Generates**:
  - `extension <Enum>: View, Screens`
  - `var body: some View`

If no `@Screen` attributes are present, View types are inferred from case names by converting them to UpperCamelCase:

```swift
@Screens
enum ScreenID {
    case gameOfLifeScreen  // → GameOfLifeScreen()
    case mosaicScreen      // → MosaicScreen()
}
```

Expands to:

```swift
extension ScreenID: View, ScreenMacros.Screens {
    @MainActor @ViewBuilder
    var body: some View {
        switch self {
        case .gameOfLifeScreen:
            GameOfLifeScreen()
        case .mosaicScreen:
            MosaicScreen()
        }
    }
}
```

### `@Screen`

- **Attached to**: enum case
- **Purpose**: Override the inferred View type and/or map parameter labels.

#### Specify View type

```swift
@Screen(CustomView.self)
case customScreen  // → CustomView()
```

#### Specify View type with parameter mapping

```swift
@Screen(DetailView.self, ["id": "detailId"])
case detail(id: Int)  // → DetailView(detailId: id)
```

#### Parameter mapping only (View type inferred)

```swift
@Screen(["foo": "image"])
case multiColorImage(foo: Image, colors: [Color])
// → MultiColorImage(image: foo, colors: colors)
```

---

## Parameter Mapping

When case labels differ from View initializer parameter names, provide a mapping via `@Screen`:

```swift
@Screens
enum ScreenID {
    @Screen(ProfileView.self, ["userId": "id", "showEdit": "editable"])
    case profile(userId: Int, showEdit: Bool)
}
```

Expands to:

```swift
extension ScreenID: View, ScreenMacros.Screens {
    @MainActor @ViewBuilder
    var body: some View {
        switch self {
        case .profile(userId: let userId, showEdit: let showEdit):
            ProfileView(id: userId, editable: showEdit)
        }
    }
}
```

- Mapping keys must match case parameter labels.
- Unmapped parameters are passed through unchanged.

---

## Access Control

`@Screens` automatically mirrors the access level of the source enum:

| Source | Generated |
|--------|-----------|
| `public enum` | `public extension` / `public var body` |
| `internal enum` | `internal extension` / `internal var body` |
| `fileprivate enum` | `fileprivate extension` / `fileprivate var body` |
| `private enum` | `private extension` / `private var body` |

Example:

```swift
@Screens
public enum ScreenID {
    case homeScreen
}
```

Expands to:

```swift
public extension ScreenID: View, ScreenMacros.Screens {
    @MainActor @ViewBuilder
    public var body: some View {
        switch self {
        case .homeScreen:
            HomeScreen()
        }
    }
}
```

This prevents mismatches like an `internal enum` with a `public body`.

---

## Associated Values

`@Screens` does not depend on concrete types of associated values. It simply:

1. Binds each case parameter to a local `let`
2. Forwards those bindings to the View initializer

This means `Optional`, `Result`, and other generic types work out of the box:

```swift
@Screens
enum ScreenID {
    case optionalDetail(id: Int?)
    case loadResult(result: Result<Int, Error>)
}
```

Expands to:

```swift
extension ScreenID: View, ScreenMacros.Screens {
    @MainActor @ViewBuilder
    var body: some View {
        switch self {
        case .optionalDetail(id: let id):
            OptionalDetail(id: id)
        case .loadResult(result: let result):
            LoadResult(result: result)
        }
    }
}
```

---

## Navigation Helpers

Enums annotated with `@Screens` automatically conform to the `Screens` protocol. This protocol provides View extensions for streamlined SwiftUI navigation.

### NavigationStack

Use `navigationDestination(_:)` to register a navigation destination:

```swift
@Screens
enum ScreenID: Hashable {
    case home
    case detail(id: Int)
}

struct ContentView: View {
    @State private var path: [ScreenID] = []

    var body: some View {
        NavigationStack(path: $path) {
            HomeView()
                .navigationDestination(ScreenID.self)
        }
    }
}
```

This is equivalent to:

```swift
.navigationDestination(for: ScreenID.self) { screen in
    screen
}
```

### Sheet

Use `sheet(item:)` to present a sheet:

```swift
@Screens
enum ModalScreen: Hashable, Identifiable {
    case settings
    case profile(userId: Int)

    var id: Self { self }
}

struct ContentView: View {
    @State private var presentedScreen: ModalScreen?

    var body: some View {
        Button("Show Settings") {
            presentedScreen = .settings
        }
        .sheet(item: $presentedScreen)
    }
}
```

### FullScreenCover (iOS / tvOS / watchOS / visionOS)

Use `fullScreenCover(item:)` for full-screen presentations:

```swift
@Screens
enum FullScreen: Hashable, Identifiable {
    case onboarding
    case login

    var id: Self { self }
}

struct ContentView: View {
    @State private var fullScreen: FullScreen?

    var body: some View {
        Button("Start Onboarding") {
            fullScreen = .onboarding
        }
        .fullScreenCover(item: $fullScreen)
    }
}
```

---

## ForEach Helpers

### ScreensForEach

Iterates over all cases of a `CaseIterable` enum with custom content:

```swift
@Screens
enum TabScreen: CaseIterable, Hashable {
    case home
    case search
    case profile

    var title: String { ... }
    var icon: String { ... }
}

TabView {
    ScreensForEach(TabScreen.self) { screen in
        screen.tabItem {
            Label(screen.title, systemImage: screen.icon)
        }
    }
}
```

### ScreensForEachView

Renders all cases directly as Views:

```swift
VStack {
    ScreensForEachView(TabScreen.self)
}
```

---

## License

ScreenMacros is available under the MIT License. See the [LICENSE](LICENSE) file for details.
