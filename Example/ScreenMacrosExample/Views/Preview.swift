import SwiftUI

// MARK: - Preview

/// Preview screen view with an unlabeled initializer parameter.
///
/// This demonstrates how `@Screens` handles unlabeled associated values.
/// The View's initializer uses `_` (unlabeled parameter), and the macro
/// correctly passes the value without a label.
///
/// ## Example
///
/// ```swift
/// @Screens
/// enum Screen {
///     case preview(Int)  // → Preview(param0) - passed without label
/// }
/// ```
struct Preview: View {
    let itemId: Int

    /// Initializer with unlabeled parameter.
    ///
    /// This matches how enum cases with unlabeled associated values work:
    /// `case preview(Int)` → `Preview(param0)` (no label)
    init(_ itemId: Int) {
        self.itemId = itemId
    }

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "eye.fill")
                .font(.system(size: 80))
                .foregroundStyle(.purple)

            Text("Preview View")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Item ID: \(itemId)")
                .font(.title2)
                .foregroundStyle(.secondary)

            Text("This view uses an unlabeled initializer")
                .font(.caption)
                .foregroundStyle(.tertiary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Preview #\(itemId)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        Preview(42)
    }
}

