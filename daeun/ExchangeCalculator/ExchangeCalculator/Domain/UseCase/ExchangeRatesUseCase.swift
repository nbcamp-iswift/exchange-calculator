//
//  ExchangeRatesUseCase.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Alamofire
import Foundation

protocol ExchangeRatesUseCase {
    func loadList() async -> Result<[ExchangeRate], AFError>
    func saveLastViewedExchangeRate(code: String)
    func deleteLastViewedExchangeRate()
}

struct DefaultExchangeRatesUseCase: ExchangeRatesUseCase {
    let repository: ExchangeRatesRepository

    func loadList() async -> Result<[ExchangeRate], AFError> {
        await repository.fetchExchangeRates()
    }

    func saveLastViewedExchangeRate(code: String) {
        repository.saveLastViewedExchangeRate(code: code)
    }

    func deleteLastViewedExchangeRate() {
        repository.deleteLastViewedExchangeRate()
    }
}
