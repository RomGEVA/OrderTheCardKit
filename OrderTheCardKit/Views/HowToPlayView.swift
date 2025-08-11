import SwiftUI

struct HowToPlayView: View {
    @Environment(\.dismiss) private var dismiss
    
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
                        Text("How to Play")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                            .foregroundColor(.purple)
                            .shadow(color: .mint.opacity(0.3), radius: 4, x: 0, y: 4)
                        Spacer()
                        GradientButton(title: "Done", action: { dismiss() }, color: .blue)
                            .frame(width: UIScreen.main.bounds.width * 0.1 + 90)
                            .padding(.leading, UIScreen.main.bounds.width * 0.25)
                    }
                    .padding(.top, 16)
                    
                    VStack(spacing: 18) {
                        HowToCard(title: "Goal", description: "Arrange the cards in the correct order by dragging them.", icon: "target")
                        HowToCard(title: "How to Play", description: "1. Read the level description\n2. Drag cards to reorder them\n3. Tap 'Check'\n4. Use 'Hint' if needed", icon: "hand.point.up.left.fill")
                        HowToCard(title: "Tips", description: "• Read the level description carefully\n• Use hints\n• Take your time to think about the correct order", icon: "lightbulb.fill")
                    }
                    .padding(.horizontal, 16)
                    .frame(maxWidth: 500)
                    Spacer(minLength: 40)
                }
                .frame(maxWidth: .infinity)
            }
            .padding(.bottom, 24)
        }
    }
}

struct HowToCard: View {
    let title: String
    let description: String
    let icon: String
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.system(size: 36))
                .foregroundColor(.mint)
                .padding(.top, 4)
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            Spacer()
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(Color.white.opacity(0.95))
                .shadow(color: .mint.opacity(0.08), radius: 8, x: 0, y: 4)
        )
    }
} 