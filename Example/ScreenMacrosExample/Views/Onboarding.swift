import SwiftUI

// MARK: - Onboarding

/// Onboarding screen view.
///
/// Presented as a full-screen cover via `FullScreen.onboarding`.
struct Onboarding: View {
    @Environment(\.dismiss) private var dismiss
    @State private var currentPage = 0

    private let pages: [(title: String, description: String, icon: String, color: Color)] = [
        (
            "Welcome",
            "ScreenMacros makes SwiftUI navigation simple and type-safe.",
            "hand.wave.fill",
            .blue
        ),
        (
            "Type-Safe",
            "Define your screens as enum cases and let the macro generate the boilerplate.",
            "checkmark.shield.fill",
            .green
        ),
        (
            "Easy Navigation",
            "Use NavigationStack, sheets, and full-screen covers with ease.",
            "arrow.triangle.turn.up.right.diamond.fill",
            .purple
        ),
    ]

    var body: some View {
        VStack {
            TabView(selection: $currentPage) {
                ForEach(0..<pages.count, id: \.self) { index in
                    OnboardingPage(
                        title: pages[index].title,
                        description: pages[index].description,
                        icon: pages[index].icon,
                        color: pages[index].color
                    )
                    .tag(index)
                }
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            Button {
                if currentPage < pages.count - 1 {
                    withAnimation {
                        currentPage += 1
                    }
                } else {
                    dismiss()
                }
            } label: {
                Text(currentPage < pages.count - 1 ? "Next" : "Get Started")
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.blue, in: RoundedRectangle(cornerRadius: 14))
                    .foregroundStyle(.white)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(Color(.systemBackground))
    }
}

// MARK: - OnboardingPage

private struct OnboardingPage: View {
    let title: String
    let description: String
    let icon: String
    let color: Color

    var body: some View {
        VStack(spacing: 24) {
            Spacer()

            Image(systemName: icon)
                .font(.system(size: 80))
                .foregroundStyle(color)

            Text(title)
                .font(.largeTitle)
                .fontWeight(.bold)

            Text(description)
                .font(.body)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)

            Spacer()
            Spacer()
        }
    }
}

#Preview {
    Onboarding()
}
