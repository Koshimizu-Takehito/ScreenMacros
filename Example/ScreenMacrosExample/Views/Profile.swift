import SwiftUI

// MARK: - Profile

/// Profile tab screen view.
///
/// This is used by `TabScreen.profile` (inferred from case name).
/// Different from `ProfileView` which is used with parameter mapping.
struct Profile: View {
    @State private var presentedModal: ModalScreen?

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Avatar
                Circle()
                    .fill(.purple.gradient)
                    .frame(width: 120, height: 120)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.white)
                    }

                // User Info
                VStack(spacing: 8) {
                    Text("My Profile")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("me@example.com")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // Actions
                VStack(spacing: 12) {
                    Button {
                        presentedModal = .editProfile(userId: 1)
                    } label: {
                        Label("Edit Profile", systemImage: "pencil")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)

                    Button {
                        presentedModal = .settings
                    } label: {
                        Label("Settings", systemImage: "gear")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.bordered)
                }
                .padding(.horizontal)

                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Profile")
        .sheet(item: $presentedModal)
    }
}

#Preview {
    NavigationStack {
        Profile()
    }
}

