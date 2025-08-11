import SwiftUI
import AVFoundation

struct GameView: View {
    let level: GameLevel
    @ObservedObject var rewardSystem: RewardSystem
    var onLevelComplete: (() -> Void)? = nil
    var onLevelSelect: (() -> Void)? = nil
    @State private var cards: [Card]
    @State private var showingHint = false
    @State private var showingSuccess = false
    @State private var incorrectCards: Set<UUID> = []
    @State private var showFinal = false
    @State private var currentLevelIndex: Int
    @State private var timeLeft: Int = 30
    @State private var showLose = false
    @State private var usedHint = false
    @State private var madeMistake = false
    @State private var showWinOverlay = false
    @State private var lastPoints = 0
    @State private var lastBonus = 0
    @State private var lastMedals: [String] = []
    @Environment(\.dismiss) private var dismiss
    @State private var timer: Timer? = nil
    @AppStorage("soundEnabled") private var soundEnabled = true
    @State private var audioPlayer: AVAudioPlayer?
    
    init(level: GameLevel, rewardSystem: RewardSystem, onLevelComplete: (() -> Void)? = nil, onLevelSelect: (() -> Void)? = nil) {
        self.level = level
        self.rewardSystem = rewardSystem
        self.onLevelComplete = onLevelComplete
        self.onLevelSelect = onLevelSelect
        _cards = State(initialValue: level.cards.shuffled())
        if let idx = GameLevel.sampleLevels.firstIndex(where: { $0.id == level.id }) {
            _currentLevelIndex = State(initialValue: idx)
        } else {
            _currentLevelIndex = State(initialValue: 0)
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
            
            VStack(spacing: 12) {
                HStack {
                    Button(action: { dismiss() }) {
                        Image(systemName: "chevron.left")
                        Text("Menu")
                    }
                    .font(.headline)
                    .foregroundColor(.blue)
                    Spacer()
                    HStack(spacing: 4) {
                        Image(systemName: "alarm.fill")
                            .foregroundColor(.red)
                        Text("\(timeLeft)s")
                            .font(.headline)
                            .foregroundColor(timeLeft <= 5 ? .red : .primary)
                    }
                    .padding(.trailing)
                }
                .padding(.top)
                
                Text(currentLevel.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.purple)
                    .shadow(color: .mint, radius: 2, x: 0, y: 2)
                
                Text(currentLevel.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                List {
                    ForEach(Array(cards.enumerated()), id: \ .element.id) { index, card in
                        CardRow(card: card, isIncorrect: incorrectCards.contains(card.id), number: index + 1)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                    }
                    .onMove(perform: moveCard)
                }
                .environment(\.editMode, .constant(.active))
                .background(Color.white.opacity(0.2))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .shadow(radius: 5)
                
                HStack(spacing: 20) {
                    GradientButton(title: "Check", action: checkOrder, color: .blue)
                        .frame(maxWidth: .infinity)
                    GradientButton(title: "Hint", action: showHint, color: .orange)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal)
            }
            .padding()
            .sheet(isPresented: $showingHint) {
                HintView(cards: currentLevel.cards)
            }
            .fullScreenCover(isPresented: $showFinal) {
                FinalView(dismiss: { dismiss() })
            }
            .fullScreenCover(isPresented: $showLose) {
                LoseView(dismiss: { dismiss() }, restart: restartLevel, onLevelSelect: {
                    onLevelSelect?()
                    dismiss()
                })
            }
            .overlay(winOverlay)
        }
        .onAppear(perform: startTimer)
        .onDisappear(perform: stopTimer)
    }
    
    var currentLevel: GameLevel {
        GameLevel.sampleLevels[currentLevelIndex]
    }
    
    var nextLevelButtonTitle: String {
        currentLevelIndex < GameLevel.sampleLevels.count - 1 ? "Next Level" : "Finish!"
    }
    
    var hasNextLevel: Bool {
        currentLevelIndex < GameLevel.sampleLevels.count - 1
    }
    
    var winOverlay: some View {
        Group {
            if showWinOverlay {
                VStack(spacing: 24) {
                    Text("Level Complete!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("You earned: +\(lastPoints) points")
                        .font(.title2)
                    if lastBonus > 0 {
                        Text("Bonus: +\(lastBonus)")
                            .font(.headline)
                            .foregroundColor(.mint)
                    }
                    if !lastMedals.isEmpty {
                        Text("Medals: \(lastMedals.joined(separator: ", "))")
                            .font(.headline)
                            .foregroundColor(.yellow)
                    }
                    HStack(spacing: 20) {
                        if hasNextLevel {
                            GradientButton(title: "Next Level", action: goToNextLevel, color: .blue)
                        }
                        GradientButton(title: "Menu", action: { dismiss() }, color: .purple)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 24).fill(Color.white).shadow(radius: 10))
                .padding(32)
            }
        }
    }
    
    private func moveCard(from source: IndexSet, to destination: Int) {
        cards.move(fromOffsets: source, toOffset: destination)
        playMoveSound()
    }
    
    private func playMoveSound() {
        guard soundEnabled else { return }
        if let url = Bundle.main.url(forResource: "buble", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error playing move sound: \(error)")
            }
        }
    }
    
    private func checkOrder() {
        let isCorrect = cards.enumerated().allSatisfy { index, card in
            card.correctPosition == index
        }
        
        if isCorrect {
            playSoundIfEnabled()
            var points = 100
            var bonus = 0
            var medals: [String] = []
            if !usedHint {
                bonus += 20
                rewardSystem.levelsWithoutHints += 1
            } else {
                rewardSystem.levelsWithoutHints = 0
            }
            if !madeMistake {
                bonus += 20
                rewardSystem.levelsNoMistakesInRow += 1
            } else {
                rewardSystem.levelsNoMistakesInRow = 0
            }
            if timeLeft >= 20 {
                medals.append("speedster")
                rewardSystem.addMedal("speedster")
            }
            if rewardSystem.levelsNoMistakesInRow >= 3 {
                medals.append("perfectionist")
                rewardSystem.addMedal("perfectionist")
            }
            let completed = rewardSystem.totalScore / 100
            if completed >= 5 { rewardSystem.addMedal("bronze"); medals.append("bronze") }
            if completed >= 15 { rewardSystem.addMedal("silver"); medals.append("silver") }
            if completed >= 30 { rewardSystem.addMedal("gold"); medals.append("gold") }
            rewardSystem.addScore(points + bonus)
            lastPoints = points
            lastBonus = bonus
            lastMedals = medals
            showWinOverlay = true
        } else {
            madeMistake = true
            incorrectCards = Set(cards.enumerated().filter { index, card in
                card.correctPosition != index
            }.map { $0.element.id })
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                incorrectCards.removeAll()
            }
        }
    }
    
    private func showHint() {
        usedHint = true
        showingHint = true
        rewardSystem.addScore(-30)
    }
    
    private func goToNextLevel() {
        if currentLevelIndex < GameLevel.sampleLevels.count - 1 {
            currentLevelIndex += 1
            cards = currentLevel.cards.shuffled()
            incorrectCards.removeAll()
            timeLeft = 30
            usedHint = false
            madeMistake = false
            showWinOverlay = false
            startTimer()
        } else {
            showFinal = true
        }
    }
    
    private func startTimer() {
        stopTimer()
        timeLeft = 30
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeLeft > 0 {
                timeLeft -= 1
            } else {
                stopTimer()
                showLose = true
            }
        }
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    private func restartLevel() {
        cards = currentLevel.cards.shuffled()
        incorrectCards.removeAll()
        timeLeft = 30
        showLose = false
        startTimer()
    }
    
    private func playSoundIfEnabled() {
        guard soundEnabled else { return }
        if let url = Bundle.main.url(forResource: "buble", withExtension: "mp3") {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: url)
                audioPlayer?.play()
            } catch {
                print("Error playing sound: \(error)")
            }
        }
    }
}

struct FinalView: View {
    let dismiss: () -> Void
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.mint.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 30) {
                Spacer()
                VStack(spacing: 24) {
                    Image(systemName: "crown.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.yellow)
                        .shadow(color: .yellow.opacity(0.3), radius: 10, x: 0, y: 6)
                    Text("Поздравляем!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.green)
                    Text("Вы прошли все уровни!")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white.opacity(0.95))
                        .shadow(color: .mint.opacity(0.10), radius: 16, x: 0, y: 8)
                )
                Spacer()
                Button(action: dismiss) {
                    Text("В меню")
                        .font(.title2)
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .padding(.horizontal, 40)
                        .padding(.vertical, 16)
                        .background(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.blue, Color.mint]),
                                startPoint: .leading,
                                endPoint: .trailing
                            )
                        )
                        .cornerRadius(18)
                        .shadow(color: .blue.opacity(0.2), radius: 8, x: 0, y: 4)
                }
                .padding(.bottom, 32)
            }
        }
    }
}

struct CardRow: View {
    let card: Card
    let isIncorrect: Bool
    let number: Int
    
    var body: some View {
        HStack {
            Text("\(number).")
                .font(.title2)
                .fontWeight(.bold)
                .foregroundColor(.gray)
                .frame(width: 32)
            Text(card.value)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundColor(.white)
                .padding(.vertical, 12)
                .padding(.horizontal, 20)
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(isIncorrect ? Color.red : Color.mint)
                        .shadow(color: .orange.opacity(0.3), radius: 5, x: 0, y: 3)
                )
            Spacer()
        }
        .padding(.vertical, 2)
    }
}

struct HintView: View {
    let cards: [Card]
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            VStack(spacing: 15) {
                Text("Correct Order:")
                    .font(.headline)
                
                ForEach(cards.sorted(by: { $0.correctPosition < $1.correctPosition })) { card in
                    Text(card.value)
                        .font(.title3)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.mint.opacity(0.2))
                        .cornerRadius(10)
                }
            }
            .padding()
            .navigationTitle("Hint")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct SuccessView: View {
    var body: some View {
        VStack {
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.green)
            
            Text("Correct!")
                .font(.title)
                .fontWeight(.bold)
                .foregroundColor(.green)
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.white)
                .shadow(radius: 10)
        )
    }
}

struct LoseView: View {
    let dismiss: () -> Void
    let restart: () -> Void
    let onLevelSelect: () -> Void
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [Color.mint.opacity(0.3), Color.purple.opacity(0.3)]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            VStack(spacing: 30) {
                Spacer()
                VStack(spacing: 24) {
                    Image(systemName: "xmark.octagon.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.red)
                        .shadow(color: .red.opacity(0.2), radius: 10, x: 0, y: 6)
                    Text("Time's up!")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.red)
                    Text("Try again!")
                        .font(.title2)
                        .foregroundColor(.primary)
                }
                .padding(.vertical, 32)
                .padding(.horizontal, 24)
                .background(
                    RoundedRectangle(cornerRadius: 28)
                        .fill(Color.white.opacity(0.95))
                        .shadow(color: .mint.opacity(0.10), radius: 16, x: 0, y: 8)
                )
                Spacer()
                HStack(spacing: 20) {
                    GradientButton(title: "Retry", action: restart, color: .orange)
                        .frame(maxWidth: .infinity)
                    GradientButton(title: "Level Select", action: onLevelSelect, color: .mint)
                        .frame(maxWidth: .infinity)
                    GradientButton(title: "Menu", action: dismiss, color: .blue)
                        .frame(maxWidth: .infinity)
                }
                .padding(.bottom, 32)
            }
        }
    }
} 
