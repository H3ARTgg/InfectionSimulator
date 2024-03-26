import UIKit

enum Urbanist: String {
    /// 400
    case regular = "Urbanist-Regular"
    /// 500
    case medium = "Urbanist-Medium"
    /// 700
    case bold = "Urbanist-Bold"
}

extension UIFont {
    static func urbanist(size: CGFloat, weight: Urbanist) -> UIFont {
        guard let font = UIFont(name: weight.rawValue, size: size) else { return UIFont.systemFont(ofSize: 20) }
        return font
    }
}
