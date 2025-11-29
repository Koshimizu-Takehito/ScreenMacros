# ScreenMacros Example

This is a sample iOS application demonstrating the features of [ScreenMacros](https://github.com/Koshimizu-Takehito/ScreenMacros).

## Features Demonstrated

### Screen Enums

| Enum | Purpose | Features |
|------|---------|----------|
| `ScreenID` | Navigation screens | Automatic type inference, parameter mapping |
| `TabScreen` | Tab bar screens | `CaseIterable`, `ScreensForEach` |
| `ModalScreen` | Sheet presentations | `Identifiable`, `sheet(item:)` |
| `FullScreen` | Full-screen covers | `fullScreenCover(item:)` |

### Navigation Patterns

- **NavigationStack**: Push/pop navigation with `navigationDestination(_:)`
- **Sheet**: Modal presentation with `sheet(item:)`
- **FullScreenCover**: Full-screen modal with `fullScreenCover(item:)`
- **TabView**: Tab-based navigation with `ScreensForEach`

## Running the Example

### Open in Xcode

```bash
cd Example
open ScreenMacrosExample.xcodeproj
```

### Trusting Macros

When building for the first time, Xcode will prompt you to trust the macro plugin. Click **"Trust & Enable"** to proceed.

If you encounter issues:

1. Go to **Build Settings** → **Swift Compiler - General**
2. Set **Enable Macros** to **Yes**

## Project Structure

```
ScreenMacrosExample/
├── ScreenMacrosExampleApp.swift  # @main entry point
├── ContentView.swift             # Root view with TabView
├── Info.plist                    # App configuration
├── Screens/
│   ├── ScreenID.swift            # @Screens enum for navigation
│   ├── TabScreen.swift           # @Screens enum for tabs
│   ├── ModalScreen.swift         # @Screens enum for sheets
│   └── FullScreen.swift          # @Screens enum for full-screen covers
└── Views/
    ├── Home.swift                # Home screen with navigation links
    ├── Detail.swift              # Detail screen (receives id parameter)
    ├── Search.swift              # Search screen with searchable
    ├── Profile.swift             # Profile tab screen
    ├── ProfileView.swift         # Profile view (parameter mapping demo)
    ├── Settings.swift            # Settings modal
    ├── EditProfile.swift         # Edit profile modal
    ├── Onboarding.swift          # Onboarding flow
    └── Login.swift               # Login screen
```

## Key Code Examples

### Basic @Screens Usage

```swift
@Screens
enum ScreenID: Hashable {
    case home           // → Home()
    case detail(id: Int) // → Detail(id: id)
}
```

### Parameter Mapping

```swift
@Screens
enum ScreenID: Hashable {
    @Screen(ProfileView.self, ["userId": "id"])
    case profile(userId: Int)  // → ProfileView(id: userId)
}
```

### Navigation Helpers

```swift
NavigationStack(path: $path) {
    HomeView()
        .navigationDestination(ScreenID.self)
}
.sheet(item: $presentedModal)
.fullScreenCover(item: $presentedFullScreen)
```

## Requirements

- iOS 17.0+
- Swift 6.0+
- Xcode 16.0+

