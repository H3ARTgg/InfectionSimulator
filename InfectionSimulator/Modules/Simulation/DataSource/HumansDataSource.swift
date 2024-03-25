import UIKit

final class HumansDataSource: UICollectionViewDiffableDataSource<Int, Human> {
    init(_ collectionView: UICollectionView) {
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HumanCell.identifier, for: indexPath) as? HumanCell else { return UICollectionViewCell() }
            return cell
        }
    }
    
    func reload(_ data: [[Human]]) {
        var snapshot = snapshot()
        snapshot.deleteAllItems()
        for (section, rows) in data.enumerated() {
            snapshot.appendSections([section])
            snapshot.appendItems(rows, toSection: section)
        }
        apply(snapshot, animatingDifferences: true)
    }
}
