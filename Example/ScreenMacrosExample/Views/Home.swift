import SwiftUI

// MARK: - Home

/// Home screen view.
///
/// Demonstrates navigation to detail screens using `NavigationLink`.
struct Home: View {
    var body: some View {
        List {
            Section {
                ForEach(1...5, id: \.self) { id in
                    NavigationLink(value: ScreenID.detail(id: id)) {
                        Label("Item \(id)", systemImage: "doc.fill")
                    }
                }
            } header: {
                Text("Items")
            }

            Section {
                NavigationLink(value: ScreenID.profile(userId: 42)) {
                    Label("View Profile", systemImage: "person.circle")
                }
            } header: {
                Text("Profile")
            }
        }
        .navigationTitle("Home")
    }
}

#Preview {
    NavigationStack {
        Home()
            .navigationDestination(ScreenID.self)
    }
}
