import ScreenMacros
import SwiftUI

// MARK: - TabScreen

/// Tab bar screen identifiers.
///
/// This enum demonstrates:
/// - `CaseIterable` conformance for iterating over all tabs
/// - Using `ScreensForEach` with TabView
///
/// ## Usage with TabView
///
/// ```swift
/// TabView {
///     ScreensForEach(TabScreen.self) { screen in
///         screen.tabItem {
///             Label(screen.title, systemImage: screen.icon)
///         }
///     }
/// }
/// ```
@Screens
enum TabScreen: CaseIterable, Hashable {
    case home
    case search
    case profile

    /// Display title for the tab
    var title: String {
        switch self {
        case .home: "Home"
        case .search: "Search"
        case .profile: "Profile"
        }
    }

    /// SF Symbol name for the tab icon
    var icon: String {
        switch self {
        case .home: "house.fill"
        case .search: "magnifyingglass"
        case .profile: "person.fill"
        }
    }
}
