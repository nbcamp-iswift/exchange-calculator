import Foundation

struct ExchangeRates: Hashable {
    let lastUpdated: Date
    let rates: [ExchangeRate]

    init(from dto: ExchangeRatesDTO) {
        lastUpdated = Date(timeIntervalSince1970: dto.lastUpdated)
        rates = Array(dto.rates)
            .map { ExchangeRate(currencyCode: $0.key, rate: $0.value) }
            .sorted(by: { $0.currencyCode < $1.currencyCode })
    }
}

struct ExchangeRate: Hashable {
    let currencyCode: String
    let rate: Double
}
