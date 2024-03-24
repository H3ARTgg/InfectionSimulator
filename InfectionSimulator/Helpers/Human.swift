import Foundation

struct Human: Hashable {
    let id = UUID()
    let number: Int
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Human, rhs: Human) -> Bool {
        return lhs.id == rhs.id
    }
}
