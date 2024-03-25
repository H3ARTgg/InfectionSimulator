final class ModulesFactory {
    static func makeMenu() -> MenuViewController {
        MenuViewController()
    }
    
    static func makeSimulation(model: SimulationParameters) -> SimulationViewController {
        SimulationViewController(model: model)
    }
}
