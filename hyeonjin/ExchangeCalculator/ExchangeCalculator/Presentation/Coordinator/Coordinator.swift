//
//  Coordinator.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/20/25.
//

import UIKit

final class Coordinator {
    let navigationController: UINavigationController
    let DIContainer: DIContainerProtocol
    let sceneUseCase: SceneUseCaseProtocol

    init(
        navigationController: UINavigationController,
        DIContainer: DIContainerProtocol,
        sceneUseCase: SceneUseCaseProtocol
    ) {
        self.navigationController = navigationController
        self.DIContainer = DIContainer
        self.sceneUseCase = sceneUseCase
    }

    func start() {
        showMainView()

        guard let (exchangeRate, isEmptyScene) = try? sceneUseCase.loadScene() else {
            return
        }

        if !isEmptyScene {
            DispatchQueue.main.async { [weak self] in
                self?.showDetailView(exchangeRate: exchangeRate)
            }
        }
    }
}

extension Coordinator {
    func showMainView() {
        let mainVC = MainViewController(
            viewModel: DIContainer.makeMainViewModel(),
            coordinator: self
        )
        navigationController.pushViewController(mainVC, animated: true)
    }

    func showDetailView(exchangeRate: ExchangeRate) {
        let detailVC = DetailViewController(
            viewModel: DetailViewModel(exchangeRate: exchangeRate),
            coordinator: self
        )
        navigationController.pushViewController(detailVC, animated: true)

        try? sceneUseCase.saveScene(exchangeRate: exchangeRate, isEmptyScene: false)
    }

    func popDetailView() {
        try? sceneUseCase.saveScene(exchangeRate: ExchangeRate.dummyEntity, isEmptyScene: true)
    }
}
