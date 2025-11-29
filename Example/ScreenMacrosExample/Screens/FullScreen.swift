import ScreenMacros
import SwiftUI

// MARK: - FullScreen

/// Full-screen cover identifiers.
///
/// This enum demonstrates:
/// - `Identifiable` conformance for full-screen presentation
/// - Using `.fullScreenCover(item:)` helper
///
/// ## Usage with FullScreenCover
///
/// ```swift
/// @State private var fullScreen: FullScreen?
///
/// Button("Start Onboarding") {
///     fullScreen = .onboarding
/// }
/// .fullScreenCover(item: $fullScreen)
/// ```
///
/// - Note: `fullScreenCover` is only available on iOS, tvOS, watchOS, and visionOS.
@Screens
enum FullScreen: Hashable, Identifiable {
    case onboarding
    case login

    var id: Self { self }
}
