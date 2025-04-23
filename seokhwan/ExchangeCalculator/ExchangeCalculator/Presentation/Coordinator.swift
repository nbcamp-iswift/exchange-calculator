import UIKit

final class Coordinator {
    private let window: UIWindow?
    private let diContainer: DIContainer
    private let navigationController = UINavigationController()

    init(window: UIWindow?, diContainer: DIContainer) {
        self.window = window
        self.diContainer = diContainer
    }

    func start() {
        let exchangeRateViewController = diContainer.makeExchangeRateViewController(with: self)
        navigationController.viewControllers = [exchangeRateViewController]
        navigationController.navigationBar.prefersLargeTitles = true

        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    func showCalculatorView(with exchangeRate: ExchangeRate) {
        let calculatorViewController = diContainer.makeCalculatorViewController(with: exchangeRate)
        navigationController.pushViewController(calculatorViewController, animated: true)
    }
}
