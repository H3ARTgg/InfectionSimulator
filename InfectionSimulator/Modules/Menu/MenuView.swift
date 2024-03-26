import UIKit

final class MenuView: UIView {
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sWhite
        label.font = .urbanist(size: 16, weight: .bold)
        label.textAlignment = .center
        label.text = "Меню"
        return label
    }()
    lazy var groupSizeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sWhite
        label.font = .urbanist(size: 12, weight: .bold)
        label.textAlignment = .natural
        label.text = "Размер группы"
        return label
    }()
    lazy var groupSizeTextField: UITextField = {
        let field = UITextField()
        field.tag = 0
        field.textColor = .sWhite
        field.tintColor = .sGreen
        field.cornerRadius(14.5)
        field.font = .urbanist(size: 12, weight: .bold)
        field.attributedPlaceholder = NSAttributedString(
            string: "Введите размер группы...", 
            attributes: [
                .font: UIFont.urbanist(size: 12, weight: .bold),
                .foregroundColor: UIColor.sLightGray
            ]
        )
        field.backgroundColor = .sGray
        field.keyboardType = .numberPad
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        return field
    }()
    lazy var infectionFactorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sWhite
        label.font = .urbanist(size: 12, weight: .bold)
        label.text = "Заразность"
        label.textAlignment = .natural
        return label
    }()
    lazy var infectionFactorTextField: UITextField = {
        let field = UITextField()
        field.tag = 1
        field.textColor = .sWhite
        field.tintColor = .sGreen
        field.cornerRadius(14.5)
        field.font = .urbanist(size: 12, weight: .bold)
        field.attributedPlaceholder = NSAttributedString(
            string: "Введите фактор заражения...",
            attributes: [
                .font: UIFont.urbanist(size: 12, weight: .bold),
                .foregroundColor: UIColor.sLightGray
            ]
        )
        field.backgroundColor = .sGray
        field.keyboardType = .numberPad
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        return field
    }()
    lazy var timeToInfectLabel: UILabel = {
        let label = UILabel()
        label.textColor = .sWhite
        label.font = .urbanist(size: 12, weight: .bold)
        label.text = "Время заражения"
        label.textAlignment = .natural
        return label
    }()
    lazy var timeToInfectTextField: UITextField = {
        let field = UITextField()
        field.tag = 2
        field.textColor = .sWhite
        field.tintColor = .sGreen
        field.cornerRadius(14.5)
        field.font = .urbanist(size: 12, weight: .bold)
        field.attributedPlaceholder = NSAttributedString(
            string: "Введите время заражения...",
            attributes: [
                .font: UIFont.urbanist(size: 12, weight: .bold),
                .foregroundColor: UIColor.sLightGray
            ]
        )
        field.backgroundColor = .sGray
        field.keyboardType = .decimalPad
        field.leftViewMode = .always
        field.leftView = UIView(frame: CGRectMake(0, 0, 10, 10))
        return field
    }()
    lazy var simulateButton: UIButton = {
        let button = UIButton.systemButton(with: UIImage(), target: nil, action: nil)
        button.backgroundColor = .sGreen
        button.setTitle("Симулировать", for: .normal)
        button.setTitleColor(.sWhite, for: .normal)
        button.cornerRadius(12)
        button.titleLabel?.font = .urbanist(size: 14, weight: .bold)
        return button
    }()
    var cancelButtons: [UIButton] = []
    var trailingConstraints: [Int: NSLayoutConstraint] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        fill()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Блокирование/Разблокирование кнопки для моделирования заражения
    func activateSimulationButton(_ isActive: Bool) {
        let alpha = isActive ? 1 : 0.75
        let color: UIColor = isActive ? .sGreen : .sLightGray
        UIView.animate(withDuration: 0.2) {
            self.simulateButton.alpha = alpha
            self.simulateButton.backgroundColor = color
            self.simulateButton.isUserInteractionEnabled = isActive
        }
    }
    
    /// Показать/Скрыть кнопку отмены
    /// - Parameter isShowing: Показать или скрыть кнопку отмены
    /// - Parameter fieldNumber: Нормер UITextField (0 = groupSizeTextField, 1 = infectionFactorTextField, 2 = timeToInfectTextField)
    func showCancelButton(_ isShowing: Bool, for fieldNumber: Int) {
        if isShowing {
            UIView.animate(withDuration: 0.25) {
                self.trailingConstraints[fieldNumber]?.constant = -(80 + 40 + 10)
                self.cancelButtons.forEach { button in
                    if button.tag == fieldNumber {
                        button.alpha = 1
                    }
                }
                self.layoutIfNeeded()
            }
        } else {
            UIView.animate(withDuration: 0.25) {
                self.trailingConstraints[fieldNumber]?.constant = -40
                self.cancelButtons.forEach { button in
                    if button.tag == fieldNumber {
                        button.alpha = 0
                    }
                }
                self.layoutIfNeeded()
            }
        }
    }
    
    func setupCancelButtons(target: Any?, action: Selector?) {
        for tag in 0...2 {
            let cancelButton = UIButton.systemButton(with: UIImage(), target: target, action: action)
            cancelButton.backgroundColor = .clear
            cancelButton.setTitle("Отмена", for: .normal)
            cancelButton.setTitleColor(.sGreen, for: .normal)
            cancelButton.titleLabel?.font = .urbanist(size: 12, weight: .bold)
            cancelButton.alpha = 0
            cancelButton.translatesAutoresizingMaskIntoConstraints = false
            cancelButton.tag = tag
            
            var centerYConstraint: NSLayoutConstraint = NSLayoutConstraint()
            switch tag {
            case 0:
                centerYConstraint = cancelButton.centerYAnchor.constraint(equalTo: groupSizeTextField.centerYAnchor)
            case 1:
                centerYConstraint = cancelButton.centerYAnchor.constraint(equalTo: infectionFactorTextField.centerYAnchor)
            case 2:
                centerYConstraint = cancelButton.centerYAnchor.constraint(equalTo: timeToInfectTextField.centerYAnchor)
            case _:
                return
            }
            
            addSubview(cancelButton)
            NSLayoutConstraint.activate([
                cancelButton.widthAnchor.constraint(equalToConstant: 80),
                cancelButton.heightAnchor.constraint(equalToConstant: 30),
                cancelButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
                centerYConstraint
            ])
            cancelButtons.append(cancelButton)
        }
    }
    
    private func fill() {
        backgroundColor = .sBlack
        
        [
            groupSizeTextField, infectionFactorTextField, timeToInfectTextField,
            groupSizeLabel, infectionFactorLabel, timeToInfectLabel,
            simulateButton, titleLabel
        ].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            addSubview($0)
        }
        
        let groupFieldTrailing = groupSizeTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        groupFieldTrailing.isActive = true
        trailingConstraints[0] = groupFieldTrailing
        
        let factorFieldTrailing = infectionFactorTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        factorFieldTrailing.isActive = true
        trailingConstraints[1] = factorFieldTrailing
        
        let timeFieldTrailing = timeToInfectTextField.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40)
        timeFieldTrailing.isActive = true
        trailingConstraints[2] = timeFieldTrailing
        
        NSLayoutConstraint.activate([
            // titleLabel
            titleLabel.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            // groupSizeLabel
            groupSizeLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 40),
            groupSizeLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            
            // groupSizeTextField
            groupSizeTextField.topAnchor.constraint(equalTo: groupSizeLabel.bottomAnchor, constant: 5),
            groupSizeTextField.heightAnchor.constraint(equalToConstant: 30),
            groupSizeTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            
            // infectionFactorLabel
            infectionFactorLabel.topAnchor.constraint(equalTo: groupSizeTextField.bottomAnchor, constant: 20),
            infectionFactorLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            
            // infectionFactorTextField
            infectionFactorTextField.topAnchor.constraint(equalTo: infectionFactorLabel.bottomAnchor, constant: 5),
            infectionFactorTextField.heightAnchor.constraint(equalToConstant: 30),
            infectionFactorTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            
            // timeToInfectLabel
            timeToInfectLabel.topAnchor.constraint(equalTo: infectionFactorTextField.bottomAnchor, constant: 20),
            timeToInfectLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 50),
            
            // timeToInfectTextField
            timeToInfectTextField.topAnchor.constraint(equalTo: timeToInfectLabel.bottomAnchor, constant: 5),
            timeToInfectTextField.heightAnchor.constraint(equalToConstant: 30),
            timeToInfectTextField.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 40),
            
            // simulateButton
            simulateButton.topAnchor.constraint(equalTo: timeToInfectTextField.bottomAnchor, constant: 40),
            simulateButton.centerXAnchor.constraint(equalTo: centerXAnchor),
            simulateButton.heightAnchor.constraint(equalToConstant: 30),
            simulateButton.widthAnchor.constraint(equalToConstant: 120)
        ])
        
        activateSimulationButton(false)
    }
}
