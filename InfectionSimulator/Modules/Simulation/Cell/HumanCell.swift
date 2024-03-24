import UIKit

protocol HumanCellDelegate: AnyObject {
    func didInfect(at indexPath: IndexPath)
}

final class HumanCell: UICollectionViewCell, Identifiable {
    static let identifier = "HumanCellId"
    var indexPath: IndexPath = IndexPath(row: 0, section: 0)
    weak var delegate: HumanCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func infect(for time: TimeInterval, at indexPath: IndexPath) {
        UIView.animate(withDuration: time) {
            self.backgroundColor = .systemRed
        } completion: { [weak self] _ in
            guard let self else { return }
            self.delegate?.didInfect(at: indexPath)
        }
    }
    
    private func fill() {
        backgroundColor = .white
    }
}
