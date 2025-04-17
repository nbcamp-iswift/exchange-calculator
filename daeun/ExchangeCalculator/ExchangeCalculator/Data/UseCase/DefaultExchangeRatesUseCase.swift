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

    func fetchExchangeRates(of baseCurrency: String) async -> Result<ExchangeRates, AFError> {
        let result = await repository.fetchExchangeRates(by: baseCurrency)

        return result.map {
            ExchangeRates(
                baseCurrency: $0.baseCode,
                rates: $0.rates.map { ExchangeRate(code: $0.key, rate: $0.value) }
            )
        }
    }
}
