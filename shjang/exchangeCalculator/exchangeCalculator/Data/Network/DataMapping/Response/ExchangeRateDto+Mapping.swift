import Foundation

struct ExchangeRateDto: Codable {
    let baseCode: String // "USD"
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case rates
    }
}

extension ExchangeRateDto {
    func toDomain(using mapper: (String) -> String = CurrencyNameMapper.name) -> [ExchangeRate] {
        rates
            .sorted { $0.key < $1.key }
            .map {
                ExchangeRate(
                    currency: $0.key,
                    country: mapper($0.key),
                    rate: $0.value
                )
            }
    }
}
