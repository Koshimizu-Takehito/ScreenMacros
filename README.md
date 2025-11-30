# ScreenMacros

[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FKoshimizu-Takehito%2FScreenMacros%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/Koshimizu-Takehito/ScreenMacros)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FKoshimizu-Takehito%2FScreenMacros%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/Koshimizu-Takehito/ScreenMacros)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Ask DeepWiki](https://deepwiki.com/badge.svg)](https://deepwiki.com/Koshimizu-Takehito/ScreenMacros)

**ScreenMacros** is a Swift macro package that generates type-safe SwiftUI views from enums.

```swift
@Screens
enum Screen {
    case home
    case detail(id: Int)
}
```

After macro expansion:

```swift
extension Screen: View, ScreenMacros.Screens {
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

You can now use `Screen` directly as a SwiftUI `View`.

## Features

- 🎯 Type-safe screen-to-view mapping
- 🔄 Automatic View protocol conformance
- 📦 Associated values support
- 🗺️ Parameter mapping
- 🧩 SwiftUI navigation helpers

## Table of Contents

- [Requirements](#requirements)
- [Installation](#installation)
- [Example Project](#example-project)
- [Macros](#macros)
- [Parameter Mapping](#parameter-mapping)
- [Access Control](#access-control)
- [Associated Values](#associated-values)
- [Navigation Helpers](#navigation-helpers)
- [ForEach Helpers](#foreach-helpers)
- [Development](#development)
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

## Example Project

A complete example iOS app is included in the `Example/` directory. It demonstrates all features of ScreenMacros:

- `@Screens` macro with automatic View type inference
- `@Screen` with explicit type and parameter mapping
- `NavigationStack` with `navigationDestination(_:)`
- `sheet(item:)` for modal presentation
- `fullScreenCover(item:)` for full-screen presentation
- `ScreensForEach` with `TabView`

### Running the Example

```bash
xed Example
```

Then build and run in Xcode. The first time you build, you may need to trust the macro:

1. Build the project (⌘B)
2. When prompted about macros, click "Trust & Enable"

### Project Structure

```
Example/
├── ScreenMacrosExample.xcodeproj
└── ScreenMacrosExample/
    ├── App.swift                     # App entry point
    ├── ContentView.swift             # Main view with TabView
    ├── Info.plist
    ├── Screens/
    │   ├── Screen.swift              # Navigation screens
    │   ├── TabScreen.swift           # Tab bar screens
    │   ├── ModalScreen.swift         # Sheet screens
    │   └── FullScreen.swift          # Full-screen cover screens
    └── Views/
        ├── Home.swift                # Home screen
        ├── Detail.swift              # Detail screen
        ├── Search.swift              # Search screen
        ├── Profile.swift             # Profile tab screen
        ├── ProfileView.swift         # Profile screen (parameter mapping)
        ├── Settings.swift            # Settings modal
        ├── EditProfile.swift         # Edit profile modal
        ├── Onboarding.swift          # Onboarding full-screen
        └── Login.swift               # Login full-screen
```

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
enum Screen {
    case home           // → Home()
    case detail(id: Int)  // → Detail(id: id)
}
```

Expands to:

```swift
extension Screen: View, ScreenMacros.Screens {
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

### `@Screen`

- **Attached to**: enum case
- **Purpose**: Override the inferred View type and/or map parameter labels.

#### Specify View type

```swift
@Screen(ProfileView.self)
case profile  // → ProfileView() instead of Profile()
```

#### Specify View type with parameter mapping

```swift
@Screen(ProfileView.self, ["userId": "id"])
case profile(userId: Int)  // → ProfileView(id: userId)
```

#### Parameter mapping only (View type inferred)

```swift
@Screen(["userId": "id"])
case editProfile(userId: Int)
// → EditProfile(id: userId)
```

---

## Parameter Mapping

When case labels differ from View initializer parameter names, provide a mapping via `@Screen`:

```swift
@Screens
enum Screen {
    @Screen(ProfileView.self, ["userId": "id"])
    case profile(userId: Int)
}
```

Expands to:

```swift
extension Screen: View, ScreenMacros.Screens {
    @MainActor @ViewBuilder
    var body: some View {
        switch self {
        case .profile(userId: let userId):
            ProfileView(id: userId)
        }
    }
}
```

- Mapping keys must match case parameter labels.
- For unlabeled associated values, use the generated parameter names (`param0`, `param1`, ...) as mapping keys.
- A mapping value of `"_"` means "call the initializer without a label" for that parameter.
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
public enum Screen {
    case home
    case detail(id: Int)
}
```

Expands to:

```swift
public extension Screen: View, ScreenMacros.Screens {
    @MainActor @ViewBuilder
    public var body: some View {
        switch self {
        case .home:
            Home()
        case .detail(id: let id):
            Detail(id: id)
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
enum Screen {
    case detail(id: Int?)
    case loadResult(result: Result<String, Error>)
}
```

Expands to:

```swift
extension Screen: View, ScreenMacros.Screens {
    @MainActor @ViewBuilder
    var body: some View {
        switch self {
        case .detail(id: let id):
            Detail(id: id)
        case .loadResult(result: let result):
            LoadResult(result: result)
        }
    }
}
```

### Unlabeled Associated Values

When an associated value has no label, it is passed to the View **without a label**. This allows Views with unlabeled initializer parameters (e.g., `init(_ id: Int)`) to work seamlessly:

```swift
@Screens
enum Screen {
    case preview(Int)                      // Unlabeled
    case article(Int, title: String)       // Mixed: unlabeled + labeled
}
```

Expands to:

```swift
extension Screen: View, ScreenMacros.Screens {
    @MainActor @ViewBuilder
    var body: some View {
        switch self {
        case .preview(let param0):
            Preview(param0)                        // Passed without label
        case .article(let param0, title: let title):
            Article(param0, title: title)          // First without label, second with label
        }
    }
}
```

If you need to add a label to an unlabeled parameter, use the mapping:

```swift
@Screen(["param0": "id"])
case preview(Int)  // → Preview(id: param0)
```

You can also use `"_"` as a mapping value when you want to remove a label from a labeled parameter:

```swift
@Screen(Detail.self, ["id": "_"])
case detail(id: Int)  // → Detail(id) – passed without label
```

---

## Navigation Helpers

Enums annotated with `@Screens` automatically conform to the `Screens` protocol. This protocol provides View extensions for streamlined SwiftUI navigation.

### NavigationStack

Use `navigationDestination(_:)` to register a navigation destination:

```swift
@Screens
enum Screen: Hashable {
    case home
    case detail(id: Int)
}

struct ContentView: View {
    @State private var path: [Screen] = []

    var body: some View {
        NavigationStack(path: $path) {
            Home()
                .navigationDestination(Screen.self)
        }
    }
}
```

This is equivalent to:

```swift
.navigationDestination(for: Screen.self) { screen in
    screen
}
```

### Sheet

Use `sheet(item:)` to present a sheet:

```swift
@Screens
enum ModalScreen: Hashable, Identifiable {
    case settings
    case editProfile(userId: Int)

    var id: Self { self }
}

struct ContentView: View {
    @State private var presentedModal: ModalScreen?

    var body: some View {
        Button("Show Settings") {
            presentedModal = .settings
        }
        .sheet(item: $presentedModal)
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

## Development

### Requirements

- macOS 15.0+
- Xcode 16.0+ (Swift 6.0+)
- [Mint](https://github.com/yonaskolb/Mint) (installed automatically via `make setup` when Homebrew is available)

### Setup

```bash
# Clone the repository
git clone https://github.com/Koshimizu-Takehito/ScreenMacros.git
cd ScreenMacros

# Install dependencies
make setup
```

### Available Commands

| Command | Description |
|---------|-------------|
| `make setup` | Install Mint (if needed) and dependencies via Mint |
| `make sync` | Pull latest changes and update all dependencies |
| `make build` | Build the package |
| `make test` | Run tests |
| `make lint` | Run SwiftLint |
| `make format` | Format code with SwiftFormat |
| `make format-check` | Check code formatting (CI) |
| `make ci` | Run all CI checks |
| `make clean` | Clean build artifacts |
| `make help` | Show available commands |

### Before Submitting a PR

Run all CI checks locally to ensure your changes pass:

```bash
make ci
```

---

## License

ScreenMacros is available under the MIT License. See the [LICENSE](LICENSE) file for details.
