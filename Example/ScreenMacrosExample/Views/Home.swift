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
                    NavigationLink(value: Screen.detail(id: id)) {
                        Label("Item \(id)", systemImage: "doc.fill")
                    }
                }
            } header: {
                Text("Items")
            }

            Section {
                ForEach(1...3, id: \.self) { id in
                    NavigationLink(value: Screen.preview(id)) {
                        Label("Preview \(id)", systemImage: "eye.fill")
                    }
                }
            } header: {
                Text("Previews (Unlabeled Parameter)")
            }

            Section {
                NavigationLink(value: Screen.profile(userId: 42)) {
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
            .navigationDestination(Screen.self)
    }
}
