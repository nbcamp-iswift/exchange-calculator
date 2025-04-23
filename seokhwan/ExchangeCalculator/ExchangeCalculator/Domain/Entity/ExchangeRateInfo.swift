import Foundation

struct ExchangeRateInfo: Hashable {
    let lastUpdated: Date
    let exchangeRates: ExchangeRates

    init() {
        lastUpdated = Date.now
        exchangeRates = []
    }

    init(lastUpdated: Date, exchangeRates: ExchangeRates) {
        self.lastUpdated = lastUpdated
        self.exchangeRates = exchangeRates
    }
}

typealias ExchangeRates = [ExchangeRate]

struct ExchangeRate: Hashable {
    let currency: String
    let country: String
    let value: Double // newRate
    let oldValue: Double // oldRate
    let isFavorite: Bool
}
