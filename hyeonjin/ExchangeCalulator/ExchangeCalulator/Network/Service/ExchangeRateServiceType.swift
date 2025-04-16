//
//  ExchangeRateServiceType.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/16/25.
//

import Foundation

enum ExchangeRateServiceType {
    case fetchExchangeRate
}

extension ExchangeRateServiceType {

    var baseURL: String {
        return "https://open.er-api.com/v6/"
    }

    var path: String {
        switch self {
        case .fetchExchangeRate: "latest/USD"
        }
    }
}
