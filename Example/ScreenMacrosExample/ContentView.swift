import ScreenMacros
import SwiftUI

// MARK: - ContentView

/// Root content view demonstrating ScreenMacros features.
///
/// This view showcases:
/// - TabView with `ScreensForEach`
/// - NavigationStack with `navigationDestination(_:)`
/// - Sheet presentation with `sheet(item:)`
/// - Full-screen cover with `fullScreenCover(item:)`
struct ContentView: View {
    @State private var selectedTab: TabScreen = .home
    @State private var navigationPath: [ScreenID] = []
    @State private var presentedModal: ModalScreen?
    @State private var presentedFullScreen: FullScreen?
    @State private var showOnboarding = false

    var body: some View {
        TabView(selection: $selectedTab) {
            // Home Tab with NavigationStack
            NavigationStack(path: $navigationPath) {
                HomeTabView(
                    presentedModal: $presentedModal,
                    presentedFullScreen: $presentedFullScreen
                )
                .navigationDestination(ScreenID.self)
            }
            .tabItem {
                Label(TabScreen.home.title, systemImage: TabScreen.home.icon)
            }
            .tag(TabScreen.home)

            // Search Tab
            NavigationStack {
                Search()
                    .navigationDestination(ScreenID.self)
            }
            .tabItem {
                Label(TabScreen.search.title, systemImage: TabScreen.search.icon)
            }
            .tag(TabScreen.search)

            // Profile Tab
            NavigationStack {
                Profile()
            }
            .tabItem {
                Label(TabScreen.profile.title, systemImage: TabScreen.profile.icon)
            }
            .tag(TabScreen.profile)
        }
        .sheet(item: $presentedModal)
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        .fullScreenCover(item: $presentedFullScreen)
        #endif
        .onAppear {
            // Show onboarding on first launch (simulated)
            if !showOnboarding {
                showOnboarding = true
                #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
                presentedFullScreen = .onboarding
                #endif
            }
        }
    }
}

// MARK: - HomeTabView

/// Home tab content with demonstration buttons.
private struct HomeTabView: View {
    @Binding var presentedModal: ModalScreen?
    @Binding var presentedFullScreen: FullScreen?

    var body: some View {
        List {
            // Navigation Section
            Section {
                ForEach(1...3, id: \.self) { id in
                    NavigationLink(value: ScreenID.detail(id: id)) {
                        Label("Item \(id)", systemImage: "doc.fill")
                    }
                }

                NavigationLink(value: ScreenID.profile(userId: 42)) {
                    Label("View Profile (Parameter Mapping)", systemImage: "person.circle")
                }
            } header: {
                Text("NavigationStack")
            } footer: {
                Text("Uses .navigationDestination(ScreenID.self)")
            }

            // Modal Section
            Section {
                Button {
                    presentedModal = .settings
                } label: {
                    Label("Settings", systemImage: "gear")
                }

                Button {
                    presentedModal = .editProfile(userId: 1)
                } label: {
                    Label("Edit Profile", systemImage: "pencil")
                }
            } header: {
                Text("Sheet")
            } footer: {
                Text("Uses .sheet(item: $presentedModal)")
            }

            // Full Screen Section
            #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
            Section {
                Button {
                    presentedFullScreen = .onboarding
                } label: {
                    Label("Onboarding", systemImage: "hand.wave.fill")
                }

                Button {
                    presentedFullScreen = .login
                } label: {
                    Label("Login", systemImage: "person.badge.key.fill")
                }
            } header: {
                Text("Full Screen Cover")
            } footer: {
                Text("Uses .fullScreenCover(item: $presentedFullScreen)")
            }
            #endif

            // About Section
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    Text("ScreenMacros Example")
                        .font(.headline)
                    Text("This app demonstrates the features of ScreenMacros, a Swift macro package that generates type-safe SwiftUI views from enums.")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            } header: {
                Text("About")
            }
        }
        .navigationTitle("ScreenMacros")
    }
}

// MARK: - Preview

#Preview {
    ContentView()
}

