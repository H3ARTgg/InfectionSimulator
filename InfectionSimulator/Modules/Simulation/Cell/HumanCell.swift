import UIKit

final class HumanCell: UICollectionViewCell {
    static let identifier = "HumanCellId"
    var model: Human?
    var isAnimating: Bool = false
    lazy var imageView: UIImageView = {
        let view = UIImageView(image: .human)
        view.contentMode = .scaleAspectFit
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
            self.imageView.image = .human.withTintColor(.systemGreen, renderingMode: .alwaysOriginal)
        }
    }
    
    func infect(for time: TimeInterval) {
        isAnimating = true
        updateImageViewWithTintColor(imageView: imageView, color: .systemGreen, duration: time) { [weak self] in
            guard let self else { return }
            self.isAnimating = false
        }
    }
    
    /// Изначальные настройки UI
    private func fill() {
        contentView.removeFromSuperview()
        backgroundColor = .clear
        addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: topAnchor),
            imageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            imageView.heightAnchor.constraint(equalToConstant: Consts.cellSize),
            imageView.widthAnchor.constraint(equalToConstant: Consts.cellSize)
        ])
    }
    
    private func updateImageViewWithTintColor(imageView: UIImageView, color: UIColor, duration: TimeInterval, completion: @escaping () -> Void) {
        guard let originalImage = imageView.image else { return }
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            // Выполняем обработку изображения в фоновом потоке
            let tintedImage = self.tintedImage(image: originalImage, color: color)
            
            DispatchQueue.main.async {
                // Возвращаемся в главный поток для обновления UI
                UIView.transition(with: imageView, duration: duration, options: .transitionCrossDissolve) {
                    imageView.image = tintedImage
                } completion: { _ in
                    completion()
                }
            }
        }
    }

    private func tintedImage(image: UIImage, color: UIColor) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: image.size)
        return renderer.image { context in
            color.setFill()
            context.fill(CGRect(origin: .zero, size: image.size))
            image.draw(at: .zero, blendMode: .destinationIn, alpha: 1.0)
        }
    }
}
