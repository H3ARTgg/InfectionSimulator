import UIKit

final class SimulationViewController: UIViewController {
    private let customView = SimulationView()
    private var dataSource: HumansDataSource?
    private let infectionTime: Int = 1
    private let infectionFactor: Int = 3
    private let groupSize: Int = 100
    // where Key is Section
    private var infectedHumans: [IndexPath] = []
    
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // DataSource initialization
        dataSource = HumansDataSource(customView.humansCollectionView, delegate: self)
        setupUI()
    }
    
    private func setupUI() {
        // Target
        customView.exitSimulationButton.addTarget(self, action: #selector(didTapExitSimulation), for: .touchUpInside)
        // Delegates
        customView.humansCollectionView.delegate = self
        customView.scrollView.delegate = self
        
        customView.setupContentView(numberOfCells: CGFloat(groupSize), cellSize: 50, spacingBetween: 5)
        var dictionary: [Int: [Human]] = [:]
        let sections = Int(sqrt(Double(groupSize)).rounded(.up))
        let rows = Int(sqrt(Double(groupSize)).rounded(.down))
        
        for section in 0..<sections {
            if section != sections - 1 {
                dictionary[section] = Array((0..<rows).map { Human(number: $0) })
            } else {
                let leftCells = groupSize % rows
                dictionary[section] = Array((0..<leftCells).map { Human(number: $0) })
            }
        }
        
        dataSource?.reload(dictionary)
    }
}

// MARK: - Collection Delegate
extension SimulationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard !infectedHumans.contains(indexPath) else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? HumanCell else { return }
        cell.infect(for: TimeInterval(infectionTime), at: indexPath)
        infectedHumans.append(indexPath)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(width: 50, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0)
    }
}

// MARK: - HumanCellDelegate
extension SimulationViewController: HumanCellDelegate {
    func didInfect(at indexPath: IndexPath) {
        let humanCollection = customView.humansCollectionView
        var infected: Int = 0
        
        func infect(cell: HumanCell, at newIndexPath: IndexPath) {
            guard !infectedHumans.contains(newIndexPath) else {
                    return // Ячейка уже заражена, прекращаем распространение
                }
            guard infected <= infectionFactor else { return }
            cell.infect(for: TimeInterval(infectionTime), at: newIndexPath)
            infected += 1
            infectedHumans.append(newIndexPath)
        }
        
        if let leftHuman = humanCollection.cellForItem(at: indexPath - (1, 0)) as? HumanCell {
            infect(cell: leftHuman, at: indexPath - (1, 0))
        }
        if let rightHuman = humanCollection.cellForItem(at: indexPath + (1, 0)) as? HumanCell {
            infect(cell: rightHuman, at: indexPath + (1, 0))
        }
        if let topHuman = humanCollection.cellForItem(at: indexPath - (0, 1)) as? HumanCell {
            infect(cell: topHuman, at: indexPath - (0, 1))
        }
        if let bottomHuman = humanCollection.cellForItem(at: indexPath + (0, 1)) as? HumanCell {
            infect(cell: bottomHuman, at: indexPath + (0, 1))
        }
    }
}

// MARK: - ScrollView Delegate
extension SimulationViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        customView.contentView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        centerContentView()
    }

    // center when zooming
    private func centerContentView() {
        let boundsSize = customView.scrollView.bounds.size
        var contentFrame = customView.contentView.frame
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self else { return }
            
            if contentFrame.size.width < boundsSize.width {
                contentFrame.origin.x = (boundsSize.width - contentFrame.size.width) / 2.0
            } else {
                contentFrame.origin.x = 0.0
            }
            if contentFrame.size.height < boundsSize.height {
                contentFrame.origin.y = (boundsSize.height - contentFrame.size.height) / 2.0
            } else {
                contentFrame.origin.y = 0.0
            }
            
            DispatchQueue.main.async {
                self.customView.contentView.frame = contentFrame
            }
        }
    }
}

// MARK: - Actions
@objc
private extension SimulationViewController {
    func didTapExitSimulation() {
        dismiss(animated: true)
    }
}
