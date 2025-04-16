//
//  ExchangeRateService.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/15/25.
//

import Foundation

final class ExchangeRateService {

    func request<T: Decodable>(_ type: ExchangeRateServiceType) async throws -> T {
        guard let url = URL(string: type.baseURL + type.path) else {
            throw ExchangeRateServiceError.invaildURL
        }

        let (data, response) = try await URLSession.shared.data(from: url)

        if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode != 200 {
            throw ExchangeRateServiceError.statusCodeError(httpResponse.statusCode)
        }

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw ExchangeRateServiceError.decodingError(error)
        }
    }
}
