//
//  MockExchangeRateServiceType.swift
//  ExchangeCalulatorTests
//
//  Created by 유현진 on 4/16/25.
//

@testable import ExchangeCalulator
import Foundation

enum MockExchangeRateServiceType {
    case testFetchExchangeRate
}

extension MockExchangeRateServiceType: ServiceTypeProtocol {

    var baseURL: String {
        return "invalid-url"
    }

    var path: String {
        switch self {
        case .testFetchExchangeRate: "latest/USD"
        }
    }
}
