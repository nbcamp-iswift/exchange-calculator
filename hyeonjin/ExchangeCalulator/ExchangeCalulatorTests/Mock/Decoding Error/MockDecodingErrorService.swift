//
//  MockDecodingErrorService.swift
//  ExchangeCalulatorTests
//
//  Created by 유현진 on 4/17/25.
//

@testable import ExchangeCalulator
import Foundation

final class MockDecodingErrorService: ServiceProtocol {

    func request<T: Decodable>(_ type: ServiceTypeProtocol) async throws -> T {

        let invalidJSON = """
                            {
                                "invalid_key": "this does not match DTO"
                            }
                          """.data(using: .utf8)!

        do {
            return try JSONDecoder().decode(T.self, from: invalidJSON)
        } catch {
            throw ExchangeRateServiceError.decodingError(error)
        }
    }
}
