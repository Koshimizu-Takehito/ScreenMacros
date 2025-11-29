# ScreenMacros

[![Swift 6.0](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![Platform](https://img.shields.io/badge/Platforms-iOS%2017+%20|%20macOS%2014+-blue.svg)](https://developer.apple.com)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

**ScreenMacros** は、画面を表す `enum` から型安全な SwiftUI `View` を自動生成する
Swift マクロパッケージです。

`enum` に `@Screens` を付け、必要に応じて各 case に `@Screen` を付けることで、
その `enum` 自体を SwiftUI の `View` として扱えるようになります。

```swift
import SwiftUI
import ScreenMacros

@Screens
enum ScreenID {
    case homeScreen
    case detailScreen(id: Int?)
    case loadResult(result: Result<Int, Error>)
}
```

マクロ展開後は次のようなコードが生成されます（View 名は case 名から推論されます）:

```swift
extension ScreenID: View, ScreenMacros.Screens {
    @MainActor @ViewBuilder
    var body: some View {
        switch self {
        case .homeScreen:
            HomeScreen()
        case .detailScreen(id: let id):
            DetailScreen(id: id)
        case .loadResult(result: let result):
            LoadResult(result: result)
        }
    }
}
```

これにより、`ScreenID` をそのまま SwiftUI の `View` として利用できます。

## 特徴

- 🎯 型安全な画面と View のマッピング
- 🔄 View プロトコルへの自動準拠
- 📦 associated value のサポート
- 🗺️ パラメータマッピング
- 🧩 SwiftUI ナビゲーションヘルパー

---

## インストール

### Swift Package Manager

`Package.swift` に **ScreenMacros** を追加します。

```swift
dependencies: [
    .package(url: "https://github.com/Koshimizu-Takehito/ScreenMacros.git", from: "1.0.0")
]
```

利用するターゲットで依存を追加します。

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

## マクロ一覧

### `@Screens`

- **付与先**: `enum`  
- **生成内容**:
  - `extension <Enum>: View, Screens`
  - `var body: some View`

`@Screen` が付いていない場合でも、case 名を UpperCamelCase に変換して
View 型を推論します。

```swift
@Screens
enum ScreenID {
    case gameOfLifeScreen  // → GameOfLifeScreen()
    case mosaicScreen      // → MosaicScreen()
}
```

### `@Screen`

- **付与先**: `enum case`  
- **用途**: 推論される View 型を上書きしたり、引数ラベルをマッピングしたりする

```swift
@Screens
enum ScreenID {
    @Screen(CustomView.self)
    case customScreen

    @Screen(DetailView.self, ["id": "detailId"])
    case detail(id: Int)

    @Screen(["foo": "image"])
    case multiColorImage(foo: Image, colors: [Color])
}
```

---

## アクセスレベルの自動調整

**`@Screens` は、元の `enum` のアクセスレベルを自動的に引き継ぎます。**

- **アクセスレベルの対応**
  - `public enum` → `public extension` / `public var body`
  - `internal enum`（修飾子なしを含む）→ `internal extension` / `internal var body`
  - `fileprivate` / `private` も同様に、`fileprivate extension` / `fileprivate var body`、`private extension` / `private var body` として反映

例:

```swift
@Screens
public enum ScreenID {
    case homeScreen
}
```

展開後:

```swift
public enum ScreenID {
    case homeScreen
}

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

これにより、

- `internal enum` に `public var body` が生成されてしまう
- `public enum` なのに extension 側が internal のまま

といったアクセスレベルの不整合を防ぎ、ライブラリとして `public` API を
安全に公開できます。

---

## Optional / Result を含む associated value のサポート

`@Screens` は、associated value の**具体的な型には依存せず**、

- case の引数ラベルを `let` で束縛し
- その束縛値を View イニシャライザにそのまま渡す

という単純なルールで動作します。

そのため、`Optional` や `Result` を含むケースもそのまま扱えます。

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

`Optional` / `Result` 以外の複雑なジェネリック型（`[String]` や `Result<[User], Error>` など）でも、
同じルールでそのまま引き回されるため、画面用の `enum` で自由に利用できます。

---

## パラメータマッピング

case の引数ラベルと View のイニシャライザの引数名が異なる場合は、
`@Screen` の第 2 引数としてマッピングを渡します。

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

- マッピングのキーは **case の引数ラベル** と一致している必要があります。
- マッピングに含まれない引数は、そのままのラベル名で View に渡されます。

---

## ナビゲーションヘルパー

`@Screens` を付与した enum は自動的に `Screens` プロトコルに準拠し、
便利なナビゲーションヘルパーが使用できるようになります。

### NavigationStack

`navigationDestination(_:)` でナビゲーション先を登録できます:

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

これは以下の冗長なコードと同等です:

```swift
.navigationDestination(for: ScreenID.self) { screen in
    screen
}
```

### Sheet

`sheet(item:)` でシートを表示できます:

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
        Button("設定を表示") {
            presentedScreen = .settings
        }
        .sheet(item: $presentedScreen)
    }
}
```

### FullScreenCover (iOS / tvOS / watchOS / visionOS)

`fullScreenCover(item:)` でフルスクリーン表示ができます:

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
        Button("オンボーディングを開始") {
            fullScreen = .onboarding
        }
        .fullScreenCover(item: $fullScreen)
    }
}
```

---

## ForEach ヘルパー

### ScreensForEach

`CaseIterable` な enum の全ケースをカスタムコンテンツで反復処理します:

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

全ケースを直接 View としてレンダリングします:

```swift
VStack {
    ScreensForEachView(TabScreen.self)
}
```


