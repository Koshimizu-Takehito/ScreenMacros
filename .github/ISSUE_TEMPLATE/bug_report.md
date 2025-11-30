---
name: Bug report
about: Create a report to help us improve
title: ''
labels: bug
assignees: Koshimizu-Takehito

---

---
name: Bug Report
about: Report a bug in ScreenMacros
title: ''
labels: bug
assignees: ''
---

**Describe the bug**

A clear and concise description of what the bug is.

**Code to reproduce**

```swift
@Screens
enum Screen {
    case example
}
```

**Expected macro expansion**

```swift
extension Screen: View, ScreenMacros.Screens {
    @MainActor @ViewBuilder
    var body: some View {
        switch self {
        case .example:
            Example()
        }
    }
}
```

**Actual behavior**

Describe what actually happened. Include the actual macro expansion or any compiler errors.

```swift
// Paste actual expansion or error message here
```

**Environment**

- ScreenMacros version: [e.g. 1.0.0]
- Swift version: [e.g. 6.0] (`swift --version`)
- Xcode version: [e.g. 16.0]
- Platform: [e.g. iOS 17, macOS 14]

**Additional context**

Add any other context about the problem here.
