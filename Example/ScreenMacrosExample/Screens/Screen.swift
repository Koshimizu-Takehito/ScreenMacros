import ScreenMacros
import SwiftUI

// MARK: - Screen

/// Main navigation screen identifiers.
///
/// This enum demonstrates:
/// - Automatic View type inference from case names
/// - Associated values for passing data between screens
/// - Unlabeled associated values (passed without labels)
/// - Parameter mapping with `@Screen`
///
/// ## Usage with NavigationStack
///
/// ```swift
/// NavigationStack(path: $path) {
///     HomeView()
///         .navigationDestination(Screen.self)
/// }
/// ```
@Screens
enum Screen: Hashable {
    /// Home screen - inferred as `Home()`
    case home

    /// Detail screen with ID - inferred as `Detail(id:)`
    case detail(id: Int)

    /// Preview screen with unlabeled parameter - inferred as `Preview(param0)`
    /// The View's init uses `init(_ itemId: Int)`, so no label is needed.
    case preview(Int)

    /// Search screen - inferred as `Search()`
    case search

    /// Profile screen with custom parameter mapping
    /// Maps `userId` to `id` in the ProfileView initializer
    @Screen(ProfileView.self, ["userId": "id"])
    case profile(userId: Int)
}
