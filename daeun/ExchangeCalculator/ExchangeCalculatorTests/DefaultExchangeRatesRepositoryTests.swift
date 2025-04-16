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
        let successCode = "KRW"

        // when
        let result = await repository.fetchExchangeRates(by: successCode)

        // then
        switch result {
            case let .success(dto):
                XCTAssertEqual(dto.baseCode, "KRW")
                XCTAssertFalse(dto.rates.isEmpty)
            case let .failure(error):
                XCTFail("Expected success but got failure: \(error)")
        }
    }

    func test_fetch_exchange_rates_failure() async {
        // given
        let failureCode = "INVALID_CODE"

        // when
        let result = await repository.fetchExchangeRates(by: failureCode)

        // then
        switch result {
            case let .success(dto):
                XCTFail("Expected failure but got success: \(dto)")
            case let .failure(error):
                XCTAssertNotNil(error)
        }
    }
}
