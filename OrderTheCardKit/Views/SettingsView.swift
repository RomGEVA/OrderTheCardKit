import SwiftUI
import AVFoundation
import StoreKit

struct SettingsView: View {
    @AppStorage("soundEnabled") private var soundEnabled = true
    @Environment(\.dismiss) private var dismiss
    @StateObject private var score = Score()
    @State private var showResetConfirmation = false
    @ObservedObject var rewardSystem: RewardSystem
    
    private let privacyURL = URL(string: "https://www.termsfeed.com/live/08d9c981-c436-4c3d-921c-bf33322d373a")!
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.mint.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Spacer()
                        Text("Settings")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                            .shadow(color: .mint.opacity(0.3), radius: 4, x: 0, y: 4)
                        Spacer()
                    }
                    .padding(.top, 16)
                    
                    VStack(spacing: 18) {
                        RoundedSection {
                            Toggle("Sound Effects", isOn: $soundEnabled)
                                .font(.title3)
                                .padding(.vertical, 8)
                        }
                        
                        RoundedSection {
                            Button(action: { showResetConfirmation = true }) {
                                Text("Reset Progress")
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.red)
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 10)
                            }
                        }
                        
                        RoundedSection {
                            SettingsLinkButton(title: "Rate this App", icon: "star.fill") {
                                if let scene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
                                    SKStoreReviewController.requestReview(in: scene)
                                }
                            }
                        }
                        
                        RoundedSection {
                            SettingsLinkButton(title: "Privacy Policy", icon: "doc.text.fill") {
                                UIApplication.shared.open(privacyURL)
                            }
                        }
                        
                        RoundedSection {
                            HStack(spacing: 16) {
                                if rewardSystem.medals.contains("bronze") {
                                    Label("Bronze", systemImage: "medal.fill").foregroundColor(.brown)
                                }
                                if rewardSystem.medals.contains("silver") {
                                    Label("Silver", systemImage: "medal.fill").foregroundColor(.gray)
                                }
                                if rewardSystem.medals.contains("gold") {
                                    Label("Gold", systemImage: "medal.fill").foregroundColor(.yellow)
                                }
                                if rewardSystem.medals.contains("speedster") {
                                    Label("Speedster", systemImage: "bolt.fill").foregroundColor(.mint)
                                }
                                if rewardSystem.medals.contains("perfectionist") {
                                    Label("Perfectionist", systemImage: "star.fill").foregroundColor(.orange)
                                }
                                if rewardSystem.medals.isEmpty {
                                    Text("No medals yet")
                                        .foregroundColor(.gray)
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    Spacer(minLength: 40)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .alert("Reset Progress", isPresented: $showResetConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Reset", role: .destructive) {
                score.resetScore()
                rewardSystem.reset()
            }
        } message: {
            Text("Are you sure you want to reset your score and medals? This action cannot be undone.")
        }
    }
    
    private func playSoundIfEnabled() {
        if soundEnabled {
            AudioServicesPlaySystemSound(1104) // Short click
        }
    }
}

struct RoundedSection<Content: View>: View {
    let content: () -> Content
    var body: some View {
        VStack { content() }
            .padding(.horizontal, 18)
            .padding(.vertical, 10)
            .background(Color.white.opacity(0.9))
            .cornerRadius(18)
            .shadow(color: .mint.opacity(0.08), radius: 8, x: 0, y: 4)
    }
}

struct SettingsLinkButton: View {
    let title: String
    let icon: String
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.mint)
                Text(title)
                    .font(.title3)
                    .foregroundColor(.blue)
                Spacer()
                Image(systemName: "chevron.right")
                    .foregroundColor(.gray)
            }
            .padding(.vertical, 10)
        }
        .buttonStyle(PlainButtonStyle())
    }
} 
