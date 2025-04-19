//
//  ServiceProtocol.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/16/25.
//

import Foundation

protocol ServiceProtocol {
    func request<T: Decodable>(_ type: ServiceTypeProtocol) async throws -> T
}
