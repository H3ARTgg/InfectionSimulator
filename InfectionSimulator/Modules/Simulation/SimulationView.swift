import UIKit

final class SimulationView: UIView {
    lazy var exitSimulationButton: UIButton = {
        let image = (UIImage(systemName: "xmark") ?? UIImage()).withTintColor(.red, renderingMode: .alwaysOriginal)
        let button = UIButton.systemButton(with: image, target: nil, action: nil)
        return button
    }()
    lazy var scrollView: UIScrollView = {
        let view = UIScrollView(frame: .zero)
        view.isScrollEnabled = true
        view.minimumZoomScale = 0.5
        view.maximumZoomScale = 1.5
        return view
    }()
    lazy var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }()
    lazy var humansCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collection = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collection.backgroundColor = .clear
        collection.register(HumanCell.self, forCellWithReuseIdentifier: HumanCell.identifier)
        collection.isScrollEnabled = false
        return collection
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupContentView(numberOfCells: CGFloat, cellSize: CGFloat, spacingBetween: CGFloat) {
        let screenSize = UIScreen.main.bounds.size
        
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self else { return }
            let width = sqrt(numberOfCells).rounded(.down) * cellSize + (sqrt(numberOfCells).rounded(.down) * spacingBetween)
            let height = sqrt(numberOfCells).rounded(.up) * cellSize + (sqrt(numberOfCells).rounded(.up) * spacingBetween)
            
            let contentViewWidth = max(width, screenSize.width)
            let contentViewHeight = max(height, screenSize.height)
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
                
                print(minimumZoomScale)
                print(self.contentView.frame.size)
            }
        }
    }
    
    private func fill() {
        backgroundColor = .black
        
        [scrollView, contentView, humansCollectionView, exitSimulationButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        addSubview(scrollView)
        addSubview(exitSimulationButton)
        scrollView.addSubview(contentView)
        contentView.addSubview(humansCollectionView)
        
        NSLayoutConstraint.activate([
            // scrollView
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
//            // contentView
//            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
//            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
//            contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor),
//            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
//            contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            
            // exitSimulationButton
            exitSimulationButton.widthAnchor.constraint(equalToConstant: 50),
            exitSimulationButton.heightAnchor.constraint(equalToConstant: 50),
            exitSimulationButton.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            exitSimulationButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
//            
//            // humansCollectionView
//            humansCollectionView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            humansCollectionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            humansCollectionView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            humansCollectionView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
}
