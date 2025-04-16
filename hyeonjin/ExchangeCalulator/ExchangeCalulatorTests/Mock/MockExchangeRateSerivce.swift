//
//  MockExchangeRateSerivce.swift
//  ExchangeCalulatorTests
//
//  Created by 유현진 on 4/16/25.
//

@testable import ExchangeCalulator
import Foundation

final class MockExchangeRateSerivce: ExchangeRateServiceProtocol {

    func request<T: Decodable>(_ type: ExchangeRateServiceType) async throws -> T {
        let mockResponse = ExchangeRateReponseDTO(
            result: "success",
            provider: "TestProvider",
            documentation: "https://example.com/docs",
            termsOfUse: "https://example.com/terms",
            timeLastUpdateUnix: 1713283200,
            timeLastUpdateUtc: "Wed, 17 Apr 2025 00:00:00 +0000",
            timeNextUpdateUnix: 1713369600,
            timeNextUpdateUtc: "Thu, 18 Apr 2025 00:00:00 +0000",
            timeEolUnix: 0,
            baseCode: "USD",
            rates: [
                "KRW": 1375.12,
                "JPY": 152.23,
                "EUR": 0.91
            ]
        )
        return mockResponse as! T
    }
}
