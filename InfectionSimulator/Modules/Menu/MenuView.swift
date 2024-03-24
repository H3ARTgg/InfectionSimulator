import UIKit

final class MenuView: UIView {
    lazy var groupSizeTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Group Size"
        field.backgroundColor = .systemGray
        field.keyboardType = .numberPad
        return field
    }()
    lazy var infectionFactorTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Infection Factor"
        field.backgroundColor = .systemGray
        field.keyboardType = .numberPad
        return field
    }()
    lazy var timeToInfectTextField: UITextField = {
        let field = UITextField()
        field.placeholder = "Time To Infect"
        field.backgroundColor = .systemGray
        field.keyboardType = .numberPad
        return field
    }()
    lazy var simulateButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(), target: nil, action: nil)
        button.cornerRadius(12)
        button.backgroundColor = .black
        button.setTitle("Simulate", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func activateSimulationButton(_ isActive: Bool) {
        let alpha = isActive ? 1 : 0.75
        UIView.animate(withDuration: 0.2) {
            self.simulateButton.alpha = alpha
            self.simulateButton.isUserInteractionEnabled = isActive
        }
    }
    
    private func fill() {
        backgroundColor = .white
        
        [groupSizeTextField, infectionFactorTextField, timeToInfectTextField, simulateButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        //
        NSLayoutConstraint.activate([
            // groupSizeTextField
            groupSizeTextField.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 20),
            groupSizeTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            groupSizeTextField.heightAnchor.constraint(equalToConstant: 30),
            groupSizeTextField.widthAnchor.constraint(equalToConstant: 100),
            
            // infectionFactorTextField
            infectionFactorTextField.topAnchor.constraint(equalTo: groupSizeTextField.bottomAnchor, constant: 20),
            infectionFactorTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            infectionFactorTextField.heightAnchor.constraint(equalToConstant: 30),
            infectionFactorTextField.widthAnchor.constraint(equalToConstant: 100),
            
            // timeToInfectTextField
            timeToInfectTextField.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: 20),
            timeToInfectTextField.centerXAnchor.constraint(equalTo: centerXAnchor),
            timeToInfectTextField.heightAnchor.constraint(equalToConstant: 30),
            timeToInfectTextField.widthAnchor.constraint(equalToConstant: 100),
            
            // simulateButton
            simulateButton.topAnchor.constraint(equalTo: timeToInfectTextField.bottomAnchor, constant: 20),
            simulateButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            simulateButton.heightAnchor.constraint(equalToConstant: 30),
            simulateButton.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        activateSimulationButton(true)
    }
}
