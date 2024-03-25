import UIKit

final class MenuViewController: UIViewController {
    // MARK: - Properties
    private let customView = MenuView()
    private var groupSize: Int = 0
    private var infectionFactor: Int = 0
    private var infectionTime: Float = 0
    
    // MARK: - Lifecycle
    override func loadView() {
        view = customView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - setupUI
    private func setupUI() {
        // Targets
        customView.simulateButton.addTarget(self, action: #selector(didTapSimulate), for: .touchUpInside)
        
        customView.groupSizeTextField.addTarget(self, action: #selector(didInteractWithField), for: .allEditingEvents)
        customView.infectionFactorTextField.addTarget(self, action: #selector(didInteractWithField), for: .allEditingEvents)
        customView.timeToInfectTextField.addTarget(self, action: #selector(didInteractWithField), for: .allEditingEvents)
    }
    
    private func isSimulationAvailable() {
        var isAvailable: [Bool] = []
        
        for field in [customView.groupSizeTextField, customView.infectionFactorTextField, customView.timeToInfectTextField] {
            field.text != "" ? isAvailable.append(true) : isAvailable.append(false)
        }
        
        isAvailable.contains(false) ? customView.activateSimulationButton(false) : customView.activateSimulationButton(true)
    }
    
    private func presentSimulationVC() {
        let model = SimulationParameters(groupSize: groupSize, infectionFactor: infectionFactor, infectionTime: infectionTime)
        let vc = ModulesFactory.makeSimulation(model: model)
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}

// MARK: - Actions
@objc
private extension MenuViewController {
    func didTapSimulate() {
        presentSimulationVC()
    }
    
    func didInteractWithField(_ sender: UITextField) {
        isSimulationAvailable()
        
        switch sender {
        case customView.groupSizeTextField:
            if let text = sender.text {
                if let groupSize = Int(text) {
                    self.groupSize = groupSize
                } else {
                    fallthrough
                }
            }
        case customView.infectionFactorTextField:
            if let text = sender.text {
                if let infectionFactor = Int(text) {
                    self.infectionFactor = infectionFactor
                } else {
                    fallthrough
                }
            }
        case customView.timeToInfectTextField:
            if let text = sender.text {
                let formattedText = text.replacingOccurrences(of: ",", with: ".")
                if let infectionTime = Float(formattedText) {
                    self.infectionTime = infectionTime
                } else {
                    fallthrough
                }
            }
        default:
            customView.activateSimulationButton(false)
            return
        }
    }
}
