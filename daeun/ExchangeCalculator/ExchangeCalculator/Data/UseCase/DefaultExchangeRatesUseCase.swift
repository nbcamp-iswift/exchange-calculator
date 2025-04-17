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

    func execute(for baseCurrency: String) async -> Result<ExchangeRates, AFError> {
        let result = await repository.fetchExchangeRates(by: baseCurrency)
        let exchangeRates = result.map {
            let sortedRates = $0.rates.sorted { $0.key < $1.key }
            return ExchangeRates(baseCurrency: $0.baseCode, rates: sortedRates.map {
                ExchangeRate(
                    code: $0.key,
                    rate: $0.value.roundedTo(digits: Constant.Digits.rate)
                )
            })
        }

        return exchangeRates
    }
}
