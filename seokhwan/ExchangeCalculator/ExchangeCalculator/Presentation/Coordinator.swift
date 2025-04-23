import UIKit

final class Coordinator {
    private let window: UIWindow?
    private let diContainer: DIContainer
    private let useCase: LastScreenUseCase
    private let navigationController = UINavigationController()

    init(window: UIWindow?, diContainer: DIContainer) {
        self.window = window
        self.diContainer = diContainer
        useCase = diContainer.makeLastScreenUseCase()
    }

    func start() {
        let exchangeRateViewController = diContainer.makeExchangeRateViewController(with: self)
        navigationController.viewControllers = [exchangeRateViewController]
        navigationController.navigationBar.prefersLargeTitles = true

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()

        Task {
            let lastScreen = await useCase.fetch()
            if lastScreen.type == .calculatorView,
               let exchangeRate = lastScreen.exchangeRate {
                await showCalculatorView(with: exchangeRate)
            }
        }
    }

    @MainActor
    func showCalculatorView(with exchangeRate: ExchangeRate) {
        let calculatorViewController = diContainer.makeCalculatorViewController(
            coordinator: self,
            exchangeRate: exchangeRate
        )
        navigationController.pushViewController(calculatorViewController, animated: true)
    }

    func updateLastScreen(to type: LastScreenType, with exchangeRate: ExchangeRate? = nil) async {
        await useCase.updateLastScreen(to: type, with: exchangeRate)
    }
}
