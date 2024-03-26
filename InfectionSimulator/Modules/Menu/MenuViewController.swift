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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    // MARK: - setupUI
    private func setupUI() {
        // Targets
        customView.simulateButton.addTarget(self, action: #selector(didTapSimulate), for: .touchUpInside)
        
        customView.groupSizeTextField.addTarget(self, action: #selector(didInteractWithField), for: .allEditingEvents)
        customView.infectionFactorTextField.addTarget(self, action: #selector(didInteractWithField), for: .allEditingEvents)
        customView.timeToInfectTextField.addTarget(self, action: #selector(didInteractWithField), for: .allEditingEvents)
        
        customView.setupCancelButtons(target: self, action: #selector(didTapCancel))
    }
    
    private func isSimulationAvailable() {
        var isAvailable: [Bool] = []
        
        for field in [customView.groupSizeTextField, customView.infectionFactorTextField, customView.timeToInfectTextField] {
            if field.text != "" {
                if let text = field.text, let number = Float(text.replacingOccurrences(of: ",", with: ".")), number != 0 {
                    isAvailable.append(true)
                } else {
                    isAvailable.append(false)
                }
            } else {
                isAvailable.append(false)
            }
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
        
        if sender.text != "" {
            customView.showCancelButton(true, for: sender.tag)
        } else {
            customView.showCancelButton(false, for: sender.tag)
        }
        
        switch sender {
        case customView.groupSizeTextField:
            if let text = sender.text {
                if let groupSize = Int(text) {
                    self.groupSize = groupSize
                }
            }
        case customView.infectionFactorTextField:
            if let text = sender.text {
                if let infectionFactor = Int(text) {
                    self.infectionFactor = infectionFactor
                }
            }
        case customView.timeToInfectTextField:
            if let text = sender.text {
                let formattedText = text.replacingOccurrences(of: ",", with: ".")
                if let infectionTime = Float(formattedText) {
                    self.infectionTime = infectionTime
                }
            }
        default:
            return
        }
    }
    
    func didTapCancel(_ sender: UIButton) {
        view.endEditing(true)
        customView.showCancelButton(false, for: sender.tag)
        switch sender.tag {
        case 0:
            customView.groupSizeTextField.text = ""
            didInteractWithField(customView.groupSizeTextField)
        case 1:
            customView.infectionFactorTextField.text = ""
            didInteractWithField(customView.infectionFactorTextField)
        case 2:
            customView.timeToInfectTextField.text = ""
            didInteractWithField(customView.timeToInfectTextField)
        case _:
            break
        }
    }
}
