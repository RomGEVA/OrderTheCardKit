import SwiftUI

struct OnboardingView: View {
    @AppStorage("hasSeenOnboarding") private var hasSeenOnboarding = false
    @State private var currentPage = 0
    
    let pages = [
        OnboardingPage(
            title: "Welcome to Order the Cards!",
            description: "A fun game where you arrange cards in the correct order.",
            systemImage: "rectangle.stack.fill"
        ),
        OnboardingPage(
            title: "Drag and Drop",
            description: "Simply drag the cards to reorder them.",
            systemImage: "hand.point.up.left.fill"
        ),
        OnboardingPage(
            title: "Hints and Checking",
            description: "Use hints if you're stuck, and check your answer!",
            systemImage: "lightbulb.fill"
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.mint.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 32) {
                    Spacer(minLength: 24)
                    TabView(selection: $currentPage) {
                        ForEach(0..<pages.count, id: \.self) { index in
                            OnboardingPageCard(page: pages[index])
                                .tag(index)
                                .padding(.horizontal, 24)
                                .frame(maxWidth: 500)
                        }
                    }
                    .tabViewStyle(.page)
                    .indexViewStyle(.page(backgroundDisplayMode: .always))
                    .frame(height: 420)
                    
                    GradientButton(title: currentPage < pages.count - 1 ? "Next" : "Get Started", action: {
                        if currentPage < pages.count - 1 {
                            withAnimation {
                                currentPage += 1
                            }
                        } else {
                            hasSeenOnboarding = true
                        }
                    }, color: .blue)
                    .padding(.bottom, 32)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 24)
        }
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let systemImage: String
}

struct OnboardingPageCard: View {
    let page: OnboardingPage
    var body: some View {
        VStack(spacing: 24) {
            Image(systemName: page.systemImage)
                .font(.system(size: 90))
                .foregroundColor(.mint)
                .padding()
                .background(
                    Circle()
                        .fill(Color.white.opacity(0.8))
                        .shadow(color: .mint.opacity(0.15), radius: 10, x: 0, y: 6)
                )
            Text(page.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.purple)
            Text(page.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
        }
        .padding(.vertical, 32)
        .padding(.horizontal, 8)
        .background(
            RoundedRectangle(cornerRadius: 28)
                .fill(Color.white.opacity(0.95))
                .shadow(color: .mint.opacity(0.08), radius: 12, x: 0, y: 8)
        )
    }
} 