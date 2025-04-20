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

    init(navigationController: UINavigationController, DIContainer: DIContainerProtocol) {
        self.navigationController = navigationController
        self.DIContainer = DIContainer
    }

    func start() {
        let mainVC = MainViewController(
            viewModel: DIContainer.makeMainViewModel(),
            coordinator: self
        )
        navigationController.pushViewController(mainVC, animated: true)
    }
}

extension Coordinator {
    func showDetailView(exchangeRate: ExchangeRate) {
        let detailVC = DetailViewController(viewModel: DetailViewModel(exchangeRate: exchangeRate))
        navigationController.pushViewController(detailVC, animated: true)
    }
}
