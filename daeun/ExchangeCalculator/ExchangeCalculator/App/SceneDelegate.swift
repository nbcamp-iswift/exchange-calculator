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
        let localFavoriteDataSource = LocalFavoriteDataSource()

        let exchangeRatesrepository = DefaultExchangeRatesRepository(
            localDataSource: localFavoriteDataSource
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
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
