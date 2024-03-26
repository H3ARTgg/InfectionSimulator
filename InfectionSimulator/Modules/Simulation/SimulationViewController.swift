import UIKit

final class SimulationViewController: UIViewController {
    // Массив индексов зараженных ячеек (людей)
    private var infectedHumans: [IndexPath] = [] {
        didSet {
            customView.infectedLabel.text = .infected + ": \(infectedHumans.count) / \(groupSize)"
        }
    }
    // Массив людей
    private var humans: [[Human]] = []
    // Diffable DataSource
    private var dataSource: HumansDataSource?
    // Кастомное вью
    private let customView = SimulationView()
    // Параметры симуляции
    private let infectionTime: Float
    private let infectionFactor: Int
    private let groupSize: Int
    
    // MARK: - Lifecycle
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // DataSource initialization
        dataSource = HumansDataSource(customView.humansCollectionView)
        setupUI()
    }
    
    // MARK: - Init
    init(model: SimulationParameters) {
        self.groupSize = model.groupSize
        self.infectionTime = model.infectionTime
        self.infectionFactor = model.infectionFactor
        super.init(nibName: nil, bundle: .main)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        // Delegates
        customView.humansCollectionView.delegate = self
        customView.scrollView.delegate = self
        
        // Target
        customView.exitSimulationButton.addTarget(self, action: #selector(didTapExitSimulation), for: .touchUpInside)
        
        // Вычисляем размеры humanCollectionView и contentView в зависимости от количества ячеек, размера ячейки и пространства между ячейками (делаем квадрат)
        customView.setupContentView(numberOfCells: CGFloat(groupSize), cellSize: Consts.cellSize, spacingBetween: Consts.spacing)
        
        // Создание первоначального массива людей от количества людей
        createIniailHumans(for: groupSize)
        
        // Увеличиваем масштаб, но не полностью, чтобы не сильно нагрузить
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false) { [weak self] _ in
            guard let self else { return }
            self.customView.scrollView.zoomScale = self.customView.scrollView.minimumZoomScale + 0.3
        }
    }
    
    /// Создает первоначальный массив людей
    /// - Parameter groupSize: Количество людей
    private func createIniailHumans(for groupSize: Int) {
        DispatchQueue.global(qos: .userInteractive).async {
            var humans: [[Human]] = []
            let sections = Int(sqrt(Double(groupSize)).rounded(.up))
            let rows = Int(sqrt(Double(groupSize)).rounded(.up))
            
            for section in 0..<sections {
                var humanSection: [Human] = []
                if section != sections - 1 {
                    humanSection.append(contentsOf: Array((0..<rows).map { Human(number: $0) }))
                } else {
                    // Если секция является последней, то вычисляем остаток
                    let leftCells = groupSize % rows
                    // Если без остатка, то заполняем последнюю секцию как обычно
                    if leftCells != 0 {
                        humanSection.append(contentsOf: Array((0..<leftCells).map { Human(number: $0) }))
                    } else {
                        // Если есть осаток, то заполняем последную секцию остатком (то есть корень из числа ячеек был не цельным)
                        humanSection.append(contentsOf: Array((0..<rows).map { Human(number: $0) }))
                    }
                }
                humans.append(humanSection)
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.humans = humans
                self.addNeighbors()
            }
        }
    }
    
    /// Добавляет соседей к каждому человеку в массиве
    private func addNeighbors() {
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self else { return }
            let oldHumans = self.humans
            var newHumans: [[Human]] = []
            
            for (section, humanSection) in oldHumans.enumerated() {
                var newHumanSection: [Human] = []
                
                for (ind, human) in humanSection.enumerated() {
                    let indexPath = IndexPath(row: ind, section: section)
                    let neighborIndexes: [IndexPath] = [indexPath - (1, 0), indexPath + (1, 0), indexPath - (0, 1), indexPath + (0, 1)]
                    
                    var neighbors: [Human] = []
                    for neighborIndex in neighborIndexes {
                        if oldHumans.indices.contains(neighborIndex.section), oldHumans[neighborIndex.section].indices.contains(neighborIndex.row) {
                            let neighbor = oldHumans[neighborIndex.section][neighborIndex.row]
                            neighbor.indexPath = neighborIndex
                            neighbors.append(neighbor)
                        }
                    }
                    human.indexPath = indexPath
                    human.neighbors = neighbors
                    newHumanSection.append(human)
                }
                newHumans.append(newHumanSection)
            }
            
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.humans = newHumans
                self.dataSource?.reload(self.humans)
            }
        }
    }
}

// MARK: - Infection
extension SimulationViewController {
    /// Если ячейка заразилась
    private func didInfect(at indexPath: IndexPath) {
        DispatchQueue.global().sync { [weak self] in
            guard let self else { return }
            
            self.infectedHumans.append(indexPath)
            self.humans[indexPath.section][indexPath.row].isInfected = true
            
            Timer.scheduledTimer(withTimeInterval: TimeInterval(infectionTime), repeats: false) { timer in
                guard self.infectedHumans.count != self.groupSize else { timer.invalidate(); return }
                
                // Количество уже зараженных соседей
                var infected: Int = 0
                
                // Перемешиваем соседей
                let humanNeighbors = self.humans[indexPath.section][indexPath.row].neighbors.shuffled()
                
                for neighbor in humanNeighbors {
                    let neighborIndex = neighbor.indexPath
                    
                    guard infected < self.infectionFactor else { break }
                    guard !self.infectedHumans.contains(neighborIndex) else { continue }
                    
                    DispatchQueue.main.async {
                        let humanCell = self.customView.humansCollectionView.cellForItem(at: neighborIndex) as? HumanCell
                        humanCell?.infect(for: TimeInterval(self.infectionTime))
                    }
                    
                    self.didInfect(at: neighbor.indexPath)
                    infected += 1
                }
                
                // Если не удалось заразить соседей, или количество зараженных недостало до предела infectionFactor
                if infected == 0 && self.infectionFactor != 0 || infected < self.infectionFactor - 1 {
                    // Ищем у соседей незараженного соседа
                    if let nextNeighbor = self.findNextUninfectedHuman(neighbors: humanNeighbors) {
                        DispatchQueue.main.async {
                            let humanCell = self.customView.humansCollectionView.cellForItem(at: nextNeighbor.indexPath) as? HumanCell
                            humanCell?.infect(for: TimeInterval(self.infectionTime))
                        }
                        self.didInfect(at: nextNeighbor.indexPath)
                        infected += 1
                    }
                }
            }
        }
    }
    
    /// Ищет незараженного соседа у соседей
    /// - Parameter neighbors: Среди каких соседей искать незараженного человека
    /// - Returns: Незараженного человека, либо **nil**
    private func findNextUninfectedHuman(neighbors: [Human]) -> Human? {
        // Очередь для хранения узлов, которые нужно исследовать
        var queue = [Human]()
        // Набор для отслеживания уже посещенных узлов
        var visited = Set<IndexPath>()
        
        // Добавляем начальные узлы (например, зараженные люди) в очередь
        for neighbor in neighbors {
            queue.append(neighbor)
            // Помечаем начальные узлы как посещенные
            visited.insert(neighbor.indexPath)
        }
        
        while !queue.isEmpty {
            let currentHuman = queue.removeFirst()
            
            // Проверяем соседей текущего человека
            for neighbor in currentHuman.neighbors {
                let neighborIndex = neighbor.indexPath
                
                // Проверяем, был ли уже посещен данный сосед
                if !visited.contains(neighborIndex) {
                    visited.insert(neighborIndex)
                    
                    // Проверяем, заражен ли сосед
                    if !neighbor.isInfected {
                        return neighbor
                    }
                    
                    // Если сосед заражен, добавляем его в очередь для дальнейшего исследования
                    queue.append(neighbor)
                }
            }
        }
        
        return nil
    }
}

// MARK: - Collection Delegate
extension SimulationViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Если уже заражен (или запущен процесс заражения), то не обрабатывать жест
        guard !infectedHumans.contains(indexPath) else { return }
        guard let cell = collectionView.cellForItem(at: indexPath) as? HumanCell else { return }
        cell.infect(for: TimeInterval(infectionTime))
        didInfect(at: indexPath)
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
    
    /// Центрировать, если зумить
    private func centerContentView() {
        let boundsSize = customView.scrollView.bounds.size
        var contentFrame = customView.contentView.frame
        
        DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let self else { return }
            
            if contentFrame.size.width < boundsSize.width {
                contentFrame.origin.x = (boundsSize.width - contentFrame.size.width) / 2
            } else {
                contentFrame.origin.x = 0.0
            }
            if contentFrame.size.height < boundsSize.height {
                contentFrame.origin.y = (boundsSize.height - contentFrame.size.height) / 2
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
