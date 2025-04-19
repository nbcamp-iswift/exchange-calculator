import Foundation

struct ExchangeRateInfo: Hashable {
    let lastUpdated: Date
    let exchangeRates: ExchangeRates

    init() {
        lastUpdated = Date.now
        exchangeRates = []
    }

    init(from dto: ExchangeRateInfoDTO, with countries: [String: String]) {
        lastUpdated = Date(timeIntervalSince1970: dto.timeLastUpdateUnix)
        exchangeRates = dto.rates
            .map { currency, value in
                let country = countries[currency] ?? "-"
                return ExchangeRate(currency: currency, country: country, value: value)
            }
            .sorted { $0.currency < $1.currency }
    }
}

typealias ExchangeRates = [ExchangeRate]

struct ExchangeRate: Hashable {
    let currency: String
    let country: String
    let value: Double
}
