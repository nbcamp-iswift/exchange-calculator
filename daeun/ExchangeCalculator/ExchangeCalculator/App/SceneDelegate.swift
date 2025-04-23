//
//  SceneDelegate.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/15/25.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo _: UISceneSession,
        options _: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let container = appDelegate.persistentContainer

        let localFavoriteDataSource = LocalFavoriteDataSource(container: container)
        let localRateChangeDataSource = LocalRateChangeDataSource(container: container)
        let localLastViewedDataSource = LocalLastViewedDataSource(container: container)

        let exchangeRatesrepository = DefaultExchangeRatesRepository(
            favoriteDataSource: localFavoriteDataSource,
            rateChangeDataSource: localRateChangeDataSource,
            lastViewedDataSource: localLastViewedDataSource
        )
        let favoriteExchangeRepository = DefaultFavoriteExchangeRepository(
            localDataSource: localFavoriteDataSource
        )

        let exchangeRatesUseCase = DefaultExchangeRatesUseCase(
            repository: exchangeRatesrepository
        )
        let favoriteExchangeUseCase = DefaultFavoriteExchangeUseCase(
            repository: favoriteExchangeRepository
        )
        let viewModel = ListViewModel(
            exchangeRatesUseCase: exchangeRatesUseCase,
            favoriteExchangeUseCase: favoriteExchangeUseCase
        )
        let rootViewController = ListViewController(listViewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: rootViewController)

        pushDetailVCIfLastViewExist(to: navigationController, appDelegate, exchangeRatesUseCase)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }

    private func pushDetailVCIfLastViewExist(
        to navigationController: UINavigationController,
        _ appDelegate: AppDelegate,
        _ exchangeRatesUseCase: ExchangeRatesUseCase
    ) {
        let container = appDelegate.persistentContainer
        let localLastViewedDataSource = LocalLastViewedDataSource(container: container)
        if let code = localLastViewedDataSource.readData() {
            let detailViewModel = DetailViewModel(
                code: code,
                convertCurrencyUseCase: DefaultConvertCurrencyUseCase(),
                exchangeRatesUseCase: exchangeRatesUseCase
            )
            let detailVC = DetailViewController(viewModel: detailViewModel)
            navigationController.pushViewController(detailVC, animated: true)
        }
    }
}
