import SwiftUI

// MARK: - Detail

/// Detail screen view.
///
/// Receives an `id` parameter from the navigation.
struct Detail: View {
    let id: Int

    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: "doc.text.fill")
                .font(.system(size: 80))
                .foregroundStyle(.blue)

            Text("Detail View")
                .font(.largeTitle)
                .fontWeight(.bold)

            Text("Item ID: \(id)")
                .font(.title2)
                .foregroundStyle(.secondary)

            Spacer()
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Detail #\(id)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        Detail(id: 42)
    }
}
