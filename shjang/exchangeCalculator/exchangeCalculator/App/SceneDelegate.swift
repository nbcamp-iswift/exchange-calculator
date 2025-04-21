import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    private func makeDefaultExchangedRateRepository() -> DefaultExchangeRateRepository {
        let appConfig = AppConfiguration()
        return DefaultExchangeRateRepository(appConfiguration: appConfig)
    }

    private func makeDefaultExchangewFavRepository() ->
        DefaultExchangeRatewFavRepostitory {
        DefaultExchangeRatewFavRepostitory(coreDataStorage: CoreDataStorage.shared)
    }

    private func makeViewModel() -> ExchangeRateViewModel {
        ExchangeRateViewModel(
            dataRepository: makeDefaultExchangedRateRepository(),
            favoriteRepository: makeDefaultExchangewFavRepository()
        )
    }

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        window
            .rootViewController =
            UINavigationController(
                rootViewController: ExchangeRateViewController(viewModel: makeViewModel())
            )
        window.makeKeyAndVisible()
        self.window = window
    }

    func sceneDidDisconnect(_: UIScene) {}

    func sceneDidBecomeActive(_: UIScene) {}

    func sceneWillResignActive(_: UIScene) {}

    func sceneWillEnterForeground(_: UIScene) {}

    func sceneDidEnterBackground(_: UIScene) {}
}
