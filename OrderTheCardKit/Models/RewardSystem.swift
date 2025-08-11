import Foundation
import SwiftUI

class RewardSystem: ObservableObject {
    @Published var totalScore: Int {
        didSet { UserDefaults.standard.set(totalScore, forKey: "totalScore") }
    }
    @Published var medals: Set<String> {
        didSet { UserDefaults.standard.set(Array(medals), forKey: "medals") }
    }
    @Published var levelsWithoutHints: Int {
        didSet { UserDefaults.standard.set(levelsWithoutHints, forKey: "levelsWithoutHints") }
    }
    @Published var levelsNoMistakesInRow: Int {
        didSet { UserDefaults.standard.set(levelsNoMistakesInRow, forKey: "levelsNoMistakesInRow") }
    }
    
    init() {
        self.totalScore = UserDefaults.standard.integer(forKey: "totalScore")
        self.medals = Set(UserDefaults.standard.stringArray(forKey: "medals") ?? [])
        self.levelsWithoutHints = UserDefaults.standard.integer(forKey: "levelsWithoutHints")
        self.levelsNoMistakesInRow = UserDefaults.standard.integer(forKey: "levelsNoMistakesInRow")
    }
    
    func addScore(_ points: Int) {
        totalScore += points
    }
    func addMedal(_ medal: String) {
        medals.insert(medal)
    }
    func reset() {
        totalScore = 0
        medals = []
        levelsWithoutHints = 0
        levelsNoMistakesInRow = 0
        UserDefaults.standard.removeObject(forKey: "totalScore")
        UserDefaults.standard.removeObject(forKey: "medals")
        UserDefaults.standard.removeObject(forKey: "levelsWithoutHints")
        UserDefaults.standard.removeObject(forKey: "levelsNoMistakesInRow")
    }
} 