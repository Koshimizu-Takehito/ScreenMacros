import SwiftUI

// MARK: - Search

/// Search screen view.
///
/// Demonstrates a simple search interface with navigation.
struct Search: View {
    @State private var searchText = ""

    var body: some View {
        List {
            if searchText.isEmpty {
                ContentUnavailableView(
                    "Search Items",
                    systemImage: "magnifyingglass",
                    description: Text("Enter a search term to find items")
                )
                .listRowBackground(Color.clear)
            } else {
                ForEach(filteredItems, id: \.self) { id in
                    NavigationLink(value: ScreenID.detail(id: id)) {
                        Label("Item \(id)", systemImage: "doc.fill")
                    }
                }
            }
        }
        .searchable(text: $searchText, prompt: "Search items...")
        .navigationTitle("Search")
    }

    private var filteredItems: [Int] {
        guard let number = Int(searchText) else {
            return Array(1...10).filter { "\($0)".contains(searchText) }
        }
        return [number]
    }
}

#Preview {
    NavigationStack {
        Search()
            .navigationDestination(ScreenID.self)
    }
}

