import SwiftUI

// MARK: - ScreenMacrosExampleApp

/// Main entry point for the ScreenMacros example application.
///
/// This app demonstrates the various features of ScreenMacros:
/// - `@Screens` macro for automatic View generation
/// - `@Screen` for explicit type specification and parameter mapping
/// - Navigation helpers (navigationDestination, sheet, fullScreenCover)
/// - ForEach helpers (ScreensForEach, ScreensForEachView)
@main
struct ScreenMacrosExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

