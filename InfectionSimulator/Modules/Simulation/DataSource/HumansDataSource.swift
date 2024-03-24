import UIKit

final class HumansDataSource: UICollectionViewDiffableDataSource<Int, Human> {
    init(_ collectionView: UICollectionView, delegate: HumanCellDelegate) {
        super.init(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HumanCell.identifier, for: indexPath) as? HumanCell else { return UICollectionViewCell() }
            cell.delegate = delegate
            cell.indexPath = indexPath
            return cell
        }
    }
    
    func reload(_ data: [Int: [Human]]) {
        let sections = data.keys.sorted(by: <)
        var snapshot = snapshot()
        snapshot.deleteAllItems()
        snapshot.appendSections(sections)
        for section in sections {
            if let rows = data[section] {
                snapshot.appendItems(rows, toSection: section)
            }
        }
        apply(snapshot, animatingDifferences: true)
    }
}
