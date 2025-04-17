import Foundation

struct ExchangeRateInfo: Hashable {
    let lastUpdated: Date
    let exchangeRates: ExchangeRates

    init() {
        lastUpdated = Date.now
        exchangeRates = []
    }

    init(from dto: ExchangeRateInfoDTO) {
        lastUpdated = Date(timeIntervalSince1970: dto.timeLastUpdateUnix)
        exchangeRates = Array(dto.rates)
            .map { ExchangeRate(currency: $0.key, value: $0.value) }
            .sorted { $0.currency < $1.currency }
    }
}

typealias ExchangeRates = [ExchangeRate]

struct ExchangeRate: Hashable {
    let currency: String
    let value: Double
}
