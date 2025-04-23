//
//  ExchangeRateReponseDTO.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/16/25.
//

import Foundation

struct ExchangeRateReponseDTO: Codable {
    let result: String
    let provider: String
    let documentation: String
    let termsOfUse: String
    let timeLastUpdateUnix: Int
    let timeLastUpdateUtc: String
    let timeNextUpdateUnix: Int
    let timeNextUpdateUtc: String
    let timeEolUnix: Int
    let baseCode: String
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case result
        case provider
        case documentation
        case termsOfUse = "terms_of_use"
        case timeLastUpdateUnix = "time_last_update_unix"
        case timeLastUpdateUtc = "time_last_update_utc"
        case timeNextUpdateUnix = "time_next_update_unix"
        case timeNextUpdateUtc = "time_next_update_utc"
        case timeEolUnix = "time_eol_unix"
        case baseCode = "base_code"
        case rates
    }

    func toEntity() -> [ExchangeRate] {
        rates.map {
            ExchangeRate(
                currencyCode: $0.key,
                value: String(format: "%.4f", $0.value),
                country: CurrencyCodeMap.map[$0.key] ?? "알 수 없음",
                isBookmark: false,
                arrowState: .none
            )
        }
        .sorted { $0.currencyCode < $1.currencyCode }
    }
}
