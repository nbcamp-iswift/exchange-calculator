//
//  DefaultExchangeRatesUseCase.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Alamofire
import Foundation

struct DefaultExchangeRatesUseCase: ExchangeRatesUseCase {
    let repository: ExchangeRatesRepository

    init(repository: ExchangeRatesRepository) {
        self.repository = repository
    }

    func fetchExchangeRates(baseCurrency: String) async -> Result<ExchangeRates, AFError> {
        let result = await repository.fetchExchangeRates(by: baseCurrency)

        return result.map { ExchangeRates(baseCurrency: $0.baseCode, rates: $0.rates) }
    }
}
