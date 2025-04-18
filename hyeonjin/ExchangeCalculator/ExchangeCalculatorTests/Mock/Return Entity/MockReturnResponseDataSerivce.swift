//
//  MockReturnResponseDataSerivce.swift
//  ExchangeCalculatorTests
//
//  Created by 유현진 on 4/16/25.
//

@testable import ExchangeCalculator
import Foundation

final class MockReturnResponseDataSerivce: ServiceProtocol {
    func request<T: Decodable>(_ type: ServiceTypeProtocol) async throws -> T {
        let mockResponse = ExchangeRateReponseDTO(
            result: "success",
            provider: "TestProvider",
            documentation: "https://example.com/docs",
            termsOfUse: "https://example.com/terms",
            timeLastUpdateUnix: 1_713_283_200,
            timeLastUpdateUtc: "Wed, 17 Apr 2025 00:00:00 +0000",
            timeNextUpdateUnix: 1_713_369_600,
            timeNextUpdateUtc: "Thu, 18 Apr 2025 00:00:00 +0000",
            timeEolUnix: 0,
            baseCode: "USD",
            rates: [
                "KRW": 1375.12,
                "JPY": 152.23,
                "EUR": 0.91
            ]
        )
        return mockResponse as T
    }
}
