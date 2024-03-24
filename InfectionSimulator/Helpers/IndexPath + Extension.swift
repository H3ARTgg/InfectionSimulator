import Foundation

extension IndexPath {
    static func +(_ lhs: IndexPath, _ rhs: (row: Int, section: Int)) -> IndexPath {
        IndexPath(row: lhs.row + rhs.row, section: lhs.section + rhs.section)
    }
    
    static func -(_ lhs: IndexPath, _ rhs: (row: Int, section: Int)) -> IndexPath {
        IndexPath(row: lhs.row - rhs.row, section: lhs.section - rhs.section)
    }
}
