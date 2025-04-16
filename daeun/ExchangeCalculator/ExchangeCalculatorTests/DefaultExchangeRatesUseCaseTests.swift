//
//  DefaultExchangeRatesUseCaseTests.swift
//  ExchangeCalculatorTests
//
//  Created by 곽다은 on 4/16/25.
//

import Alamofire
@testable import ExchangeCalculator
import XCTest

final class DefaultExchangeRatesUseCaseTests: XCTestCase {
    let mockRepository = MockExchangeRatesRepository()
    var useCase: DefaultExchangeRatesUseCase!

    override func setUp() {
        useCase = DefaultExchangeRatesUseCase(repository: mockRepository)
    }

    func test_mapEntity_success() async {
        // given
        mockRepository.stubbedResult = .success(
            ExchangeRatesDTO(baseCode: "USD", rates: ["KRW": 1400])
        )

        // when
        let result = await useCase.fetchExchangeRates(baseCurrency: "USD")

        // then
        switch result {
        case let .success(entity):
            XCTAssertEqual(entity.rates["KRW"], 1400)
        case let .failure(error):
            XCTFail("Expected success but got failure: \(error)")
        }
    }

    func test_invalidCode_failure() async {
        // given
        let failureCode = "INVALID_CODE"
        let failureURL = Constant.baseURL + failureCode
        mockRepository.stubbedResult = .failure(AFError.invalidURL(url: failureURL))

        // when
        let result = await mockRepository.fetchExchangeRates(by: failureCode)

        switch result {
        case let .success(entity):
            XCTFail("Expected failure but got success: \(entity)")
        case let .failure(error):
            XCTAssertNotNil(error)
        }
    }
}
