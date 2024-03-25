import Foundation

final class Human: Hashable {
    let uuid = UUID()
    let number: Int
    var isInfected: Bool = false
    var neighbors: [Human] = []
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    
    init(number: Int) {
        self.number = number
        self.isInfected = false
        self.neighbors = []
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(uuid)
    }
    
    static func == (lhs: Human, rhs: Human) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}
