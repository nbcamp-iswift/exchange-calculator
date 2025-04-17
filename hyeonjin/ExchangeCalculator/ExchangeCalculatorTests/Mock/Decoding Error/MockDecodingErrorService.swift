//
//  MockDecodingErrorService.swift
//  ExchangeCalculatorTests
//
//  Created by 유현진 on 4/17/25.
//

@testable import ExchangeCalculator
import Foundation

final class MockDecodingErrorService: ServiceProtocol {

    func request<T: Decodable>(_ type: ServiceTypeProtocol) async throws -> T {

        let invalidJSON = Data("invalid json".utf8)

        do {
            return try JSONDecoder().decode(T.self, from: invalidJSON)
        } catch {
            throw ExchangeRateServiceError.decodingError(error)
        }
    }
}
