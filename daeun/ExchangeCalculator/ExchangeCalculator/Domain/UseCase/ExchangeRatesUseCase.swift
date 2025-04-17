//
//  ExchangeRatesUseCase.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Alamofire
import Foundation

protocol ExchangeRatesUseCase {
    func execute() async -> Result<[ExchangeRate], AFError>
}

struct DefaultExchangeRatesUseCase: ExchangeRatesUseCase {
    let repository: ExchangeRatesRepository

    func execute() async -> Result<[ExchangeRate], AFError> {
        await repository.fetchExchangeRates()
    }
}
