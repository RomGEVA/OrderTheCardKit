import SwiftUI

struct LevelSelectView: View {
    let rewardSystem: RewardSystem
    @AppStorage("completedLevels") private var completedLevelsData: Data = Data()
    @Environment(\.dismiss) private var dismiss
    @State private var selectedLevel: GameLevel?
    
    var completedLevels: Set<Int> {
        (try? JSONDecoder().decode(Set<Int>.self, from: completedLevelsData)) ?? []
    }
    
    func markLevelCompleted(_ id: Int) {
        var set = completedLevels
        set.insert(id)
        if let data = try? JSONEncoder().encode(set) {
            completedLevelsData = data
        }
    }
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.mint.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 20) {
                Text("Level Select")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 18) {
                        ForEach(GameLevel.sampleLevels) { level in
                            let isUnlocked = !level.isSpecial || rewardSystem.totalScore >= level.requiredPoints
                            LevelCardView(
                                title: level.title,
                                description: level.description,
                                isCompleted: completedLevels.contains(level.levelID),
                                isLocked: !isUnlocked,
                                isActive: false,
                                isSpecial: level.isSpecial,
                                requiredPoints: level.requiredPoints,
                                userPoints: rewardSystem.totalScore
                            )
                            .onTapGesture {
                                if isUnlocked {
                                    selectedLevel = level
                                }
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
                
                GradientButton(title: "Menu", action: { dismiss() }, color: .blue)
                    .padding(.bottom, 24)
            }
            .sheet(item: $selectedLevel) { level in
                GameViewWithProgress(level: level, rewardSystem: rewardSystem, onComplete: {
                    markLevelCompleted(level.levelID)
                }, onLevelSelect: {
                    // Implementation of onLevelSelect
                })
            }
        }
    }
}

struct LevelCardView: View {
    let title: String
    let description: String
    let isCompleted: Bool
    let isLocked: Bool
    let isActive: Bool
    let isSpecial: Bool
    let requiredPoints: Int
    let userPoints: Int
    
    var body: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 6) {
                HStack {
                    Text(title)
                        .font(.headline)
                        .fontWeight(.bold)
                        .foregroundColor(isLocked ? .gray : (isSpecial ? .yellow : .primary))
                    if isSpecial {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                    }
                }
                Text(description)
                    .font(.caption)
                    .foregroundColor(isLocked ? .gray : .secondary)
                if isSpecial && isLocked {
                    HStack(spacing: 6) {
                        Image(systemName: "lock.fill").foregroundColor(.gray)
                        Text("Need \(requiredPoints) points to unlock")
                            .font(.caption2)
                            .foregroundColor(.gray)
                        if userPoints < requiredPoints {
                            Text("(\(requiredPoints - userPoints) more)")
                                .font(.caption2)
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            Spacer()
            if isCompleted {
                Image(systemName: "checkmark.seal.fill")
                    .font(.title2)
                    .foregroundColor(.green)
                    .shadow(color: .green.opacity(0.3), radius: 4, x: 0, y: 2)
            } else if isLocked {
                Image(systemName: "lock.fill")
                    .font(.title2)
                    .foregroundColor(.gray)
            } else if isSpecial {
                Image(systemName: "star.fill")
                    .font(.title2)
                    .foregroundColor(.yellow)
            }
        }
        .padding(.vertical, 18)
        .padding(.horizontal, 18)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(isLocked ? Color.white.opacity(0.5) : (isSpecial ? Color.yellow.opacity(0.13) : Color.white))
                .shadow(color: isSpecial ? Color.yellow.opacity(0.18) : (isActive ? Color.mint.opacity(0.25) : Color.black.opacity(0.07)), radius: isActive ? 10 : 4, x: 0, y: isActive ? 6 : 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(isActive ? Color.mint : Color.clear, lineWidth: 2)
                )
        )
        .opacity(isLocked ? 0.5 : 1.0)
    }
}

struct GameViewWithProgress: View {
    let level: GameLevel
    let rewardSystem: RewardSystem
    let onComplete: () -> Void
    let onLevelSelect: () -> Void
    @Environment(\.dismiss) private var dismiss
    var body: some View {
        GameView(level: level, rewardSystem: rewardSystem, onLevelComplete: {
            onComplete()
            dismiss()
        }, onLevelSelect: {
            onLevelSelect()
            dismiss()
        })
    }
} 
