//
//  DIContainer.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/20/25.
//

import Foundation

final class DIContainer: DIContainerProtocol {
    func makeMainViewModel() -> MainViewModel {
        let repository = ExchangeRateRepository(service: ExchangeRateService())
        let useCase = ExchangeRateUseCase(repository: repository)
        return MainViewModel(exchangeUseCase: useCase)
    }
}
