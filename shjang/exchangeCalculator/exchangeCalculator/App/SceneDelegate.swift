import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    private lazy var coreDataStack = CoreDataStack.shared
    private lazy var appStateStore = DefaultAppStateStore(context: coreDataStack.viewContext)

    private func makeDefaultExchangedRateRepository() -> DefaultExchangeRateRepository {
        let appConfig = AppConfiguration()
        return DefaultExchangeRateRepository(appConfiguration: appConfig)
    }

    private func makeDefaultCoreDataRepository() ->
        DefaultCoreDataRepostitory {
        DefaultCoreDataRepostitory(coreDataStack: coreDataStack)
    }

    private func makeExchangeRateViewModel() -> ExchangeRateViewModel {
        ExchangeRateViewModel(
            dataRepository: makeDefaultExchangedRateRepository(),
            coreDataRepository: makeDefaultCoreDataRepository(),
            appDataRepository: appStateStore
        )
    }

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)

        let lastScreen = appStateStore.loadLastScreen()
        let exchangedRateViewController = ExchangeRateViewController(
            viewModel: makeExchangeRateViewModel()
        )
        let navigationController = UINavigationController(
            rootViewController: exchangedRateViewController
        )

        if lastScreen.screen == .calculator {
            let allRate = makeDefaultCoreDataRepository().getAllExchangedRate()
            if let matched = allRate.first(where: { $0.currency == lastScreen.selectedCurrency }) {
                let viewModel = ExchangeRateCalculatorViewModel(
                    currency: matched.currency,
                    countryName: matched.countryCode,
                    exchangeRate: matched.currency,
                    appDataRepository: appStateStore
                )
                let calculatorVC = ExchangeRateCalculatorViewController(viewModel: viewModel)
                navigationController.pushViewController(calculatorVC, animated: false)
            }
        }

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_: UIScene) {}

    func sceneDidBecomeActive(_: UIScene) {}

    func sceneWillResignActive(_: UIScene) {}

    func sceneWillEnterForeground(_: UIScene) {}

    func sceneDidEnterBackground(_: UIScene) {}
}
