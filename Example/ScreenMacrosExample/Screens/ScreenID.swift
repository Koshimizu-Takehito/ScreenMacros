import ScreenMacros
import SwiftUI

// MARK: - ScreenID

/// Main navigation screen identifiers.
///
/// This enum demonstrates:
/// - Automatic View type inference from case names
/// - Associated values for passing data between screens
/// - Parameter mapping with `@Screen`
///
/// ## Usage with NavigationStack
///
/// ```swift
/// NavigationStack(path: $path) {
///     HomeView()
///         .navigationDestination(ScreenID.self)
/// }
/// ```
@Screens
enum ScreenID: Hashable {
    /// Home screen - inferred as `Home()`
    case home

    /// Detail screen with ID - inferred as `Detail(id:)`
    case detail(id: Int)

    /// Search screen - inferred as `Search()`
    case search

    /// Profile screen with custom parameter mapping
    /// Maps `userId` to `id` in the ProfileView initializer
    @Screen(ProfileView.self, ["userId": "id"])
    case profile(userId: Int)
}

