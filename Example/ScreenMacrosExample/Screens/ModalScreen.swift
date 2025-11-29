import ScreenMacros
import SwiftUI

// MARK: - ModalScreen

/// Modal sheet screen identifiers.
///
/// This enum demonstrates:
/// - `Identifiable` conformance for sheet presentation
/// - Using `.sheet(item:)` helper
///
/// ## Usage with Sheet
///
/// ```swift
/// @State private var presentedScreen: ModalScreen?
///
/// Button("Show Settings") {
///     presentedScreen = .settings
/// }
/// .sheet(item: $presentedScreen)
/// ```
@Screens
enum ModalScreen: Hashable, Identifiable {
    case settings
    case editProfile(userId: Int)

    var id: Self { self }
}
