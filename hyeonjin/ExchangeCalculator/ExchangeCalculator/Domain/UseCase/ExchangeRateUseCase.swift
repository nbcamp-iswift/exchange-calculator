//
//  ExchangeRateUseCase.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/20/25.
//

import Foundation
import RxSwift

final class ExchangeRateUseCase: ExchangeRateUseCaseProtocol {
    let repository: ExchangeRateRepositoryProtocol

    init(repository: ExchangeRateRepositoryProtocol) {
        self.repository = repository
    }

    func fetchExchangeRates() -> Single<[ExchangeRate]> {
        repository.fetchExchangeRates()
    }
}
