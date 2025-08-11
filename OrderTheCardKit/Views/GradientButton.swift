import SwiftUI

struct GradientButton: View {
    let title: String
    let action: () -> Void
    let color: Color
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .padding(.vertical, 10)
                .padding(.horizontal, 24)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [color, .mint]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                    .cornerRadius(14)
                    .shadow(color: color.opacity(0.18), radius: 6, x: 0, y: 3)
                )
        }
        .buttonStyle(PlainButtonStyle())
    }
} 