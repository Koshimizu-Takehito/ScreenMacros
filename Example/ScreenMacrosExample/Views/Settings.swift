import SwiftUI

// MARK: - Settings

/// Settings screen view.
///
/// Presented as a modal sheet via `ModalScreen.settings`.
struct Settings: View {
    @Environment(\.dismiss) private var dismiss
    @State private var notificationsEnabled = true
    @State private var darkModeEnabled = false
    @State private var selectedLanguage = "English"

    private let languages = ["English", "日本語", "Español", "Français"]

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Notifications", isOn: $notificationsEnabled)
                    Toggle("Dark Mode", isOn: $darkModeEnabled)
                } header: {
                    Text("Preferences")
                }

                Section {
                    Picker("Language", selection: $selectedLanguage) {
                        ForEach(languages, id: \.self) { language in
                            Text(language).tag(language)
                        }
                    }
                } header: {
                    Text("Localization")
                }

                Section {
                    Link(destination: URL(string: "https://github.com/Koshimizu-Takehito/ScreenMacros")!) {
                        Label("GitHub Repository", systemImage: "link")
                    }

                    NavigationLink {
                        AboutView()
                    } label: {
                        Label("About", systemImage: "info.circle")
                    }
                } header: {
                    Text("Info")
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - AboutView

private struct AboutView: View {
    var body: some View {
        List {
            Section {
                LabeledContent("Version", value: "1.0.0")
                LabeledContent("Build", value: "1")
            }

            Section {
                Text("ScreenMacros is a Swift macro package that generates type-safe SwiftUI views from enums.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
            } header: {
                Text("About")
            }
        }
        .navigationTitle("About")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    Settings()
}
