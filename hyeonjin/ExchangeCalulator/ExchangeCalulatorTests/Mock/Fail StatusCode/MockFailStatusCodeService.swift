//
//  MockFailStatusCodeService.swift
//  ExchangeCalulatorTests
//
//  Created by 유현진 on 4/17/25.
//

@testable import ExchangeCalulator
import Foundation

final class MockFailStatusCodeService: ServiceProtocol {
    func request<T: Decodable>(_ type: ServiceTypeProtocol) async throws -> T {

        let invalidURL = URL(string: "https://example.com")!

        let response = HTTPURLResponse(
                    url: invalidURL,
                    statusCode: 404,
                    httpVersion: nil,
                    headerFields: nil
                )!

        let dummyData = "{}".data(using: .utf8)!

        if response.statusCode != 200 {
            throw ExchangeRateServiceError.statusCodeError(response.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: dummyData)
    }
}
