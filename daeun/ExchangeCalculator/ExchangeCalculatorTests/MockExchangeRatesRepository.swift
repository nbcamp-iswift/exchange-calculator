//
//  MockExchangeRatesRepository.swift
//  ExchangeCalculatorTests
//
//  Created by 곽다은 on 4/16/25.
//

import Alamofire
@testable import ExchangeCalculator

final class MockExchangeRatesRepository: ExchangeRatesRepository {
    var stubbedResult: Result<ExchangeRatesDTO, AFError>!

    func fetchExchangeRates(by _: String) async -> Result<ExchangeRatesDTO, AFError> {
        stubbedResult
    }
}
