import SwiftUI

// MARK: - ProfileView

/// Profile screen view.
///
/// Note: This view uses `id` as the parameter name, which is mapped
/// from `userId` in the `Screen.profile(userId:)` case using
/// `@Screen(ProfileView.self, ["userId": "id"])`.
struct ProfileView: View {
    let id: Int

    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Avatar
                Circle()
                    .fill(.blue.gradient)
                    .frame(width: 120, height: 120)
                    .overlay {
                        Image(systemName: "person.fill")
                            .font(.system(size: 50))
                            .foregroundStyle(.white)
                    }

                // User Info
                VStack(spacing: 8) {
                    Text("User \(id)")
                        .font(.title)
                        .fontWeight(.bold)

                    Text("user\(id)@example.com")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                // Stats
                HStack(spacing: 40) {
                    StatItem(title: "Posts", value: "\(id * 10)")
                    StatItem(title: "Followers", value: "\(id * 100)")
                    StatItem(title: "Following", value: "\(id * 5)")
                }
                .padding()
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))

                Spacer()
            }
            .padding()
        }
        .background(Color(.systemGroupedBackground))
        .navigationTitle("Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// MARK: - StatItem

private struct StatItem: View {
    let title: String
    let value: String

    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.semibold)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    NavigationStack {
        ProfileView(id: 42)
    }
}

