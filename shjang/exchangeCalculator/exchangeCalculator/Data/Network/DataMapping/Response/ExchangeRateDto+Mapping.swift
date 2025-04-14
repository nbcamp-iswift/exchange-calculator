import Foundation

extension ExchangeRateDto {
    func toDomain() -> [ExchangeRate] {
        rates.map { ExchangeRate(currency: $0.key, rate: $0.value) }
    }
}
