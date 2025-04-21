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

    enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case rates
    }

    func toEntity() -> [ExchangeRate] {
        rates
            .map { key, value in
                let roundedValue = value.roundedTo(digits: Constant.Digits.rate)
                return ExchangeRate(
                    currencyCode: key,
                    countryName: CurrencyCodeMapper.name(for: key),
                    value: roundedValue
                )
            }
            .sorted { $0.currencyCode < $1.currencyCode }
    }
}
