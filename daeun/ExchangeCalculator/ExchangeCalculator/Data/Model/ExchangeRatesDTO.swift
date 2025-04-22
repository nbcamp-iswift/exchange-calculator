//
//  ExchangeRatesDTO.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Foundation

struct ExchangeRatesDTO: Decodable {
    let baseCode: String
    let rates: [String: Double]
    let lastUpdated: String

    enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case rates
        case lastUpdated = "time_last_update_utc"
    }
}
