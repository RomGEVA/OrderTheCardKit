import Foundation

struct Card: Identifiable, Equatable {
    let id = UUID()
    let value: String
    let correctPosition: Int
    
    static func == (lhs: Card, rhs: Card) -> Bool {
        lhs.id == rhs.id
    }
} 