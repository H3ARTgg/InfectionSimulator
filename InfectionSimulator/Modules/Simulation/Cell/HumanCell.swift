import UIKit

final class HumanCell: UICollectionViewCell {
    static let identifier = "HumanCellId"
    var model: Human?
    var isAnimating: Bool = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        if isAnimating {
            self.layer.removeAllAnimations()
            self.backgroundColor = .systemRed
        }
    }
    
    func infect(for time: TimeInterval) {
        isAnimating = true
        UIView.animate(withDuration: time) {
            self.backgroundColor = .systemRed
        } completion: { _ in
            self.isAnimating = false
        }
    }
    
    /// Изначальный настройки UI
    private func fill() {
        contentView.removeFromSuperview()
        backgroundColor = .white
    }
}
