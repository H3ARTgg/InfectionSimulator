import Foundation

// Енам с ключами Localizable
enum KeysLocale: String {
    // MenuView
    case menu = "menu"
    case simulate = "simulate"
    case cancel = "cancel"
    case groupSize = "group_size"
    case groupSizePlaceholder = "group_size_placeholder"
    case infectionFactor = "infection_factor"
    case infectionFactorPlaceholder = "infection_factor_placeholder"
    case infectionTime = "infection_time"
    case infectionTimePlaceholder = "infection_time_placeholder"
    
    // SimulationView
    case infected = "infected"
}

extension String {
    // MenuView
    static let menu = NSLocalizedString(KeysLocale.menu.rawValue, comment: "")
    static let simulate = NSLocalizedString(KeysLocale.simulate.rawValue, comment: "")
    static let cancel = NSLocalizedString(KeysLocale.cancel.rawValue, comment: "")
    static let groupSize = NSLocalizedString(KeysLocale.groupSize.rawValue, comment: "")
    static let groupSizePlaceholder = NSLocalizedString(KeysLocale.groupSizePlaceholder.rawValue, comment: "")
    static let infectionFactor = NSLocalizedString(KeysLocale.infectionFactor.rawValue, comment: "")
    static let infectionFactorPlaceholder = NSLocalizedString(KeysLocale.infectionFactorPlaceholder.rawValue, comment: "")
    static let infectionTime = NSLocalizedString(KeysLocale.infectionTime.rawValue, comment: "")
    static let infectionTimePlaceholder = NSLocalizedString(KeysLocale.infectionTimePlaceholder.rawValue, comment: "")
    
    // SimulationView
    static let infected = NSLocalizedString(KeysLocale.infected.rawValue, comment: "")
}
