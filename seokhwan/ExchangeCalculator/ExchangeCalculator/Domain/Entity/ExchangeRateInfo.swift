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
    let value: Double
    let oldValue: Double
    let isFavorite: Bool
}
