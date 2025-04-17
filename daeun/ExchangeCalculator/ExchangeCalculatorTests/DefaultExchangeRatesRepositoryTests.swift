//
//  DefaultExchangeRatesRepositoryTests.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/15/25.
//

@testable import ExchangeCalculator
import XCTest

final class DefaultExchangeRatesRepositoryTests: XCTestCase {
    var repository: DefaultExchangeRatesRepository!

    override func setUp() {
        repository = DefaultExchangeRatesRepository()
    }

    func test_fetch_exchange_rates_success() async {
        // given

        // when
        let result = await repository.fetchExchangeRates()

        // then
        switch result {
        case let .success(rates):
            XCTAssertFalse(rates.isEmpty)
        case let .failure(error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }
}
