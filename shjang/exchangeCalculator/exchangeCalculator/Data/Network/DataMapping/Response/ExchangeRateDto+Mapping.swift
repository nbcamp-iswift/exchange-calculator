import Foundation

struct ExchangeRateDto: Codable {
    let baseCode: String // "USD"
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case rates
    }
}

enum ExchangeRateMapper {
    static func map(
        dto: ExchangeRateDto,
        using mapper: (String) -> String = CurrencyNameMapper.name
    ) -> [ExchangeRate] {
        dto.rates
            .sorted { $0.key < $1.key }
            .map { key, value in
                ExchangeRate(
                    currency: key,
                    country: mapper(key),
                    rate: String(format: "%.4f", value)
                )
            }
    }
}
