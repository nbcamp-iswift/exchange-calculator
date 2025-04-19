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
        let repository = DefaultExchangeRatesRepository()
        let useCase = DefaultExchangeRatesUseCase(repository: repository)
        let viewModel = ListViewModel(exchangeRatesUseCase: useCase)
        let rootViewController = ListViewController(listViewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: rootViewController)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
}
