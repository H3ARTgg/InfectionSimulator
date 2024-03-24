import UIKit

extension UIView {
    func cornerRadius(_ value: CGFloat, maskedCorners: CACornerMask? = nil) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = value
        
        if let maskedCorners {
            self.layer.maskedCorners = maskedCorners
        }
    }
}
