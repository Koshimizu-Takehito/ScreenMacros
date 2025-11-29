# ScreenMacros

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platforms-iOS%2017+%20|%20macOS%2014+-blue.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**ScreenMacros** は、enum から型安全な SwiftUI View を自動生成する Swift マクロパッケージです。

```swift
@Screens
enum ScreenID {
    case home
    case detail(id: Int)
}
```

展開結果:

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

これにより、`ScreenID` をそのまま SwiftUI の `View` として利用できます。

## 特徴

- 🎯 型安全な画面と View のマッピング
- 🔄 View プロトコルへの自動準拠
- 📦 Associated values のサポート
- 🗺️ パラメータマッピング
- 🧩 SwiftUI ナビゲーションヘルパー

## 目次

- [動作環境](#動作環境)
- [インストール](#インストール)
- [マクロ](#マクロ)
- [パラメータマッピング](#パラメータマッピング)
- [アクセスレベル](#アクセスレベル)
- [Associated Values](#associated-values)
- [ナビゲーションヘルパー](#ナビゲーションヘルパー)
- [ForEach ヘルパー](#foreach-ヘルパー)
- [ライセンス](#ライセンス)

## 動作環境

- Swift 6.0+
- iOS 17.0+ / macOS 14.0+ / tvOS 17.0+ / watchOS 10.0+ / visionOS 1.0+

---

## インストール

### Swift Package Manager

`Package.swift` に **ScreenMacros** を追加します:

```swift
dependencies: [
    .package(url: "https://github.com/Koshimizu-Takehito/ScreenMacros.git", from: "1.0.0")
]
```

ターゲットに依存を追加します:

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
2. URL を入力: `https://github.com/Koshimizu-Takehito/ScreenMacros.git`
3. バージョンを選択: `1.0.0` 以降

---

## マクロ

### `@Screens`

- **付与先**: enum
- **生成内容**:
  - `extension <Enum>: View, Screens`
  - `var body: some View`

`@Screen` が付いていない場合、case 名を UpperCamelCase に変換して View 型を推論します:

```swift
@Screens
enum ScreenID {
    case gameOfLifeScreen  // → GameOfLifeScreen()
    case mosaicScreen      // → MosaicScreen()
}
```

展開結果:

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

- **付与先**: enum case
- **用途**: 推論される View 型を上書き、または引数ラベルをマッピング

#### View 型を指定

```swift
@Screen(CustomView.self)
case customScreen  // → CustomView()
```

#### View 型とパラメータマッピングを指定

```swift
@Screen(DetailView.self, ["id": "detailId"])
case detail(id: Int)  // → DetailView(detailId: id)
```

#### パラメータマッピングのみ（View 型は推論）

```swift
@Screen(["foo": "image"])
case multiColorImage(foo: Image, colors: [Color])
// → MultiColorImage(image: foo, colors: colors)
```

---

## パラメータマッピング

case の引数ラベルと View イニシャライザの引数名が異なる場合、`@Screen` でマッピングを指定します:

```swift
@Screens
enum ScreenID {
    @Screen(ProfileView.self, ["userId": "id", "showEdit": "editable"])
    case profile(userId: Int, showEdit: Bool)
}
```

展開結果:

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

- マッピングのキーは case の引数ラベルと一致する必要があります。
- マッピングに含まれない引数は、そのままのラベル名で渡されます。

---

## アクセスレベル

`@Screens` は元の enum のアクセスレベルを自動的に引き継ぎます:

| 元の enum | 生成されるコード |
|-----------|------------------|
| `public enum` | `public extension` / `public var body` |
| `internal enum` | `internal extension` / `internal var body` |
| `fileprivate enum` | `fileprivate extension` / `fileprivate var body` |
| `private enum` | `private extension` / `private var body` |

例:

```swift
@Screens
public enum ScreenID {
    case homeScreen
}
```

展開結果:

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

これにより、`internal enum` に `public body` が生成されるような不整合を防ぎます。

---

## Associated Values

`@Screens` は associated values の具体的な型に依存しません。単純に:

1. 各 case パラメータを `let` で束縛
2. その束縛値を View イニシャライザに転送

そのため、`Optional`、`Result`、その他のジェネリック型もそのまま動作します:

```swift
@Screens
enum ScreenID {
    case optionalDetail(id: Int?)
    case loadResult(result: Result<Int, Error>)
}
```

展開結果:

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

## ナビゲーションヘルパー

`@Screens` を付与した enum は自動的に `Screens` プロトコルに準拠します。このプロトコルは SwiftUI ナビゲーションを簡潔にする View 拡張を提供します。

### NavigationStack

`navigationDestination(_:)` でナビゲーション先を登録:

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

これは以下と同等です:

```swift
.navigationDestination(for: ScreenID.self) { screen in
    screen
}
```

### Sheet

`sheet(item:)` でシートを表示:

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

`fullScreenCover(item:)` でフルスクリーン表示:

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

## ForEach ヘルパー

### ScreensForEach

`CaseIterable` な enum の全ケースをカスタムコンテンツで反復処理:

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

全ケースを直接 View としてレンダリング:

```swift
VStack {
    ScreensForEachView(TabScreen.self)
}
```

---

## ライセンス

ScreenMacros は MIT ライセンスで提供されています。詳細は [LICENSE](LICENSE) ファイルを参照してください。
