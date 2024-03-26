import UIKit

final class SimulationView: UIView {
    lazy var exitSimulationButton: UIButton = {
        let button = UIButton.systemButton(with: .exitSimulation, target: nil, action: nil)
        return button
    }()
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.backgroundColor = .clear
        view.isScrollEnabled = true
        view.minimumZoomScale = 0.5
        view.maximumZoomScale = 1.5
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        return view
    }()
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var infectedLabel: UILabel = {
        let label = UILabel()
        label.font = .urbanist(size: 16, weight: .bold)
        label.textColor = .sWhite
        label.textAlignment = .center
        return label
    }()
    lazy var infectByPanButton: UIButton = {
        let button = UIButton.systemButton(with: .pan, target: nil, action: nil)
        button.backgroundColor = .clear
        button.tintColor = .sWhite
        return button
    }()
    lazy var humansCollectionView: UICollectionView = {
        // Для оптимизации, чтобы были фиксированные значения
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumInteritemSpacing = Consts.spacing
        flowLayout.sectionInset = UIEdgeInsets(top: Consts.spacing, left: 0, bottom: 0, right: 0)
        flowLayout.estimatedItemSize = CGSize(width: Consts.cellSize, height: Consts.cellSize)
        
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.backgroundColor = .clear
        collection.register(HumanCell.self, forCellWithReuseIdentifier: HumanCell.identifier)
        collection.isScrollEnabled = false
        collection.bounces = false
        collection.showsHorizontalScrollIndicator = false
        collection.showsVerticalScrollIndicator = false
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Устанавливает размеры contentView и humansCollectionView
    /// - Parameters:
    ///   - numberOfCells: Количество ячеек (людей)
    ///   - cellSize: Размер ячейки
    ///   - spacingBetween: Расстояние между ячейками
    func setupContentView(numberOfCells: CGFloat, cellSize: CGFloat, spacingBetween: CGFloat) {
        // Изначальная установка infectedLabel
        infectedLabel.text = .infected + ": 0 / \(Int(numberOfCells))"
        // Текуюшие размеры экрана
        let screenSize = UIScreen.main.bounds.size
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self else { return }
            let width = sqrt(numberOfCells).rounded(.up) * cellSize + (sqrt(numberOfCells).rounded(.up) * spacingBetween)
            let height = sqrt(numberOfCells).rounded(.up) * cellSize + (sqrt(numberOfCells).rounded(.up) * spacingBetween)
            
            let contentViewWidth = max(width, screenSize.width)
            let contentViewHeight = max(height, screenSize.height)
            // Вычисляем минимальный зум
            let minimumZoomScale = contentViewWidth < screenSize.width ? 0.5 : screenSize.width / contentViewWidth
            
            DispatchQueue.main.async {
                self.contentView.frame = CGRectMake(0, 0, contentViewWidth, contentViewHeight)
                self.humansCollectionView.frame = CGRectMake(
                    (self.contentView.frame.width - width) / 2,
                    (self.contentView.frame.height - height) / 2, 
                    width, 
                    height
                )
                self.scrollView.contentSize = self.contentView.frame.size
                self.scrollView.minimumZoomScale = minimumZoomScale
            }
        }
    }
    
    private func fill() {
        backgroundColor = .sBlack
        
        [
            scrollView, contentView, humansCollectionView, 
            exitSimulationButton, infectedLabel, infectByPanButton
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(scrollView)
        addSubview(exitSimulationButton)
        addSubview(infectedLabel)
        addSubview(infectByPanButton)
        scrollView.addSubview(contentView)
        contentView.addSubview(humansCollectionView)
        
        NSLayoutConstraint.activate([
            // scrollView
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            // exitSimulationButton
            exitSimulationButton.widthAnchor.constraint(equalToConstant: 30),
            exitSimulationButton.heightAnchor.constraint(equalToConstant: 30),
            exitSimulationButton.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 13),
            exitSimulationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            // infectedLabel
            infectedLabel.centerYAnchor.constraint(equalTo: exitSimulationButton.centerYAnchor),
            infectedLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // infectBySwipeButton
            infectByPanButton.widthAnchor.constraint(equalToConstant: 30),
            infectByPanButton.heightAnchor.constraint(equalToConstant: 30),
            infectByPanButton.topAnchor.constraint(equalTo: exitSimulationButton.bottomAnchor, constant: 13),
            infectByPanButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30)
        ])
    }
}
