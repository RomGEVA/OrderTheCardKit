import SwiftUI
import SafariServices

struct MainMenuView: View {
    @StateObject private var rewardSystem = RewardSystem()
    @State private var showSettings = false
    @State private var showHowToPlay = false
    @State private var showOnboarding = false
    @State private var showGame = false
    @State private var showPrivacyPolicy = false
    @State private var selectedLevel: GameLevel? = GameLevel.sampleLevels.first
    @State private var showingLevels = false
    
    var body: some View {
        NavigationView {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.mint.opacity(0.3), Color.purple.opacity(0.3)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .ignoresSafeArea()
                
                VStack(spacing: 32) {
                    Text("Order the Cards")
                        .font(.system(size: 44, weight: .heavy))
                        .foregroundColor(.purple)
                        .shadow(color: .mint.opacity(0.3), radius: 4, x: 0, y: 4)
                        .padding(.top, 40)
                        .frame(maxWidth: .infinity, alignment: .center)
                    
                    Text("Score: \(rewardSystem.totalScore)")
                        .font(.system(size: 24, weight: .medium))
                        .foregroundColor(.purple)
                        .padding(.top, 8)
                    
                    HStack(spacing: 16) {
                        if rewardSystem.medals.contains("bronze") {
                            Image(systemName: "medal.fill").foregroundColor(.brown)
                        }
                        if rewardSystem.medals.contains("silver") {
                            Image(systemName: "medal.fill").foregroundColor(.gray)
                        }
                        if rewardSystem.medals.contains("gold") {
                            Image(systemName: "medal.fill").foregroundColor(.yellow)
                        }
                        if rewardSystem.medals.contains("speedster") {
                            Image(systemName: "bolt.fill").foregroundColor(.mint)
                        }
                        if rewardSystem.medals.contains("perfectionist") {
                            Image(systemName: "star.fill").foregroundColor(.orange)
                        }
                    }
                    
                    VStack(spacing: 24) {
                        MenuCardButton(title: "Start Game", color: .blue, icon: "play.fill") { showGame = true }
                        MenuCardButton(title: "Level Select", color: .mint, icon: "list.number") { showingLevels = true }
                        MenuCardButton(title: "How to Play", color: .orange, icon: "questionmark.circle.fill") { showHowToPlay = true }
                        MenuCardButton(title: "Settings", color: .purple, icon: "gearshape.fill") { showSettings = true }
                    }
                    .padding(.horizontal, 24)
                    .frame(maxWidth: 500)
                    Spacer(minLength: 40)
                }
                .frame(maxWidth: .infinity)
                
                VStack {
                    Spacer()
                    Button(action: { showPrivacyPolicy = true }) {
                        Text("Privacy Policy")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.bottom, 8)
                }
            }
            .navigationBarHidden(true)
            .sheet(isPresented: $showSettings) {
                SettingsView(rewardSystem: rewardSystem)
            }
            .sheet(isPresented: $showHowToPlay) {
                HowToPlayView()
            }
            .sheet(isPresented: $showOnboarding) {
                OnboardingView()
            }
            .sheet(isPresented: $showPrivacyPolicy) {
                SafariView(url: URL(string: "https://example.com/privacy")!)
            }
            .sheet(isPresented: $showingLevels) {
                LevelSelectView(rewardSystem: rewardSystem)
            }
            .fullScreenCover(isPresented: $showGame) {
                if let level = selectedLevel {
                    GameView(level: level, rewardSystem: rewardSystem, onLevelSelect: {
                        showingLevels = true
                    })
                }
            }
        }
    }
}

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    func makeUIViewController(context: Context) -> SFSafariViewController {
        SFSafariViewController(url: url)
    }
    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}

struct MenuCardButton: View {
    let title: String
    let color: Color
    let icon: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title2)
                    .foregroundColor(.white)
                Text(title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                Spacer()
            }
            .padding(.vertical, 22)
            .padding(.horizontal, 28)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [color, .mint]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
                .cornerRadius(20)
                .shadow(color: color.opacity(0.25), radius: 10, x: 0, y: 6)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .scaleEffectOnTap()
    }
}

extension View {
    func scaleEffectOnTap() -> some View {
        self.modifier(ScaleEffectOnTap())
    }
}

struct ScaleEffectOnTap: ViewModifier {
    @State private var pressed = false
    func body(content: Content) -> some View {
        content
            .scaleEffect(pressed ? 0.96 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.5), value: pressed)
            .gesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { _ in pressed = true }
                    .onEnded { _ in pressed = false }
            )
    }
} 