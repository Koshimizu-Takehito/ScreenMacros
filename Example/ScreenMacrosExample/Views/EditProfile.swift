import SwiftUI

// MARK: - EditProfile

/// Edit profile screen view.
///
/// Presented as a modal sheet via `ModalScreen.editProfile(userId:)`.
struct EditProfile: View {
    @Environment(\.dismiss) private var dismiss

    let userId: Int

    @State private var name: String = ""
    @State private var bio: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(.purple.gradient)
                            .frame(width: 100, height: 100)
                            .overlay {
                                Image(systemName: "person.fill")
                                    .font(.system(size: 40))
                                    .foregroundStyle(.white)
                            }
                            .overlay(alignment: .bottomTrailing) {
                                Image(systemName: "camera.fill")
                                    .font(.caption)
                                    .padding(6)
                                    .background(.blue, in: Circle())
                                    .foregroundStyle(.white)
                            }
                        Spacer()
                    }
                    .listRowBackground(Color.clear)
                }

                Section {
                    TextField("Name", text: $name)
                    TextField("Bio", text: $bio, axis: .vertical)
                        .lineLimit(3...6)
                } header: {
                    Text("Profile Information")
                }

                Section {
                    LabeledContent("User ID", value: "\(userId)")
                } header: {
                    Text("Account")
                }
            }
            .navigationTitle("Edit Profile")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        dismiss()
                    }
                    .fontWeight(.semibold)
                }
            }
            .onAppear {
                name = "User \(userId)"
                bio = "This is user \(userId)'s bio."
            }
        }
    }
}

#Preview {
    EditProfile(userId: 42)
}
