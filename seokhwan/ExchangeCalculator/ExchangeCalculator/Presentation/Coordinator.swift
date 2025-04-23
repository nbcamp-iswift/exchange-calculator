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

            if lastScreen == "CalculatorView" {
                await showCalculatorView(
                    with: ExchangeRate(
                        currency: "AAA",
                        country: "테스트",
                        value: 100.0,
                        oldValue: 105.0,
                        isFavorite: false
                    ))
                // TODO: 임시 값
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

    func updateLastScreen(_ lastScreen: String) async {
        await useCase.update(to: lastScreen)
    }
}
