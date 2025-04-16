//
//  ExchangeRateServiceProtocol.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/16/25.
//

import Foundation

protocol ExchangeRateServiceProtocol {
    func request<T: Decodable>(
        _ type: ExchangeRateServiceType
    ) async throws -> T
}
