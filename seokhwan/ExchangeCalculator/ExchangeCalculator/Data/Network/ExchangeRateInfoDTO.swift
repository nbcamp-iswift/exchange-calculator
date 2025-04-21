import Foundation

struct ExchangeRateInfoDTO: Codable {
    let timeLastUpdateUnix: TimeInterval
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case timeLastUpdateUnix = "time_last_update_unix"
        case rates
    }

    func toEntity(with countries: [String: String]) -> ExchangeRateInfo {
        let exchangeRates = rates
            .map { currency, value in
                let country = countries[currency] ?? "-"
                return ExchangeRate(
                    currency: currency,
                    country: country,
                    value: value,
                    isFavorite: false // TODO: favorite 값을 CoreData에서 fetch 해서 대입하기
                )
            }
            .sorted { $0.currency < $1.currency }

        return ExchangeRateInfo(
            lastUpdated: Date(timeIntervalSince1970: timeLastUpdateUnix),
            exchangeRates: exchangeRates
        )
    }
}
