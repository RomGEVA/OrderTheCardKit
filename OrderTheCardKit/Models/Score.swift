import Foundation

class Score: ObservableObject {
    @Published var totalScore: Int {
        didSet {
            UserDefaults.standard.set(totalScore, forKey: "totalScore")
        }
    }
    
    init() {
        self.totalScore = UserDefaults.standard.integer(forKey: "totalScore")
    }
    
    func addScore(_ points: Int) {
        totalScore += points
    }
    
    func resetScore() {
        totalScore = 0
    }
} 