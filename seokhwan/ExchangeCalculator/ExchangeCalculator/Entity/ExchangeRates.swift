import Foundation

struct ExchangeRates {
    let lastUpdated: Date
    let rates: [String: Double]

    init(from dto: ExchangeRatesDTO) {
        lastUpdated = Date(timeIntervalSince1970: dto.lastUpdated)
        rates = dto.rates
    }
}
