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
    static func map(dto: ExchangeRateDto) -> [ExchangeRate] {
        dto.rates
            .map { key, value in
                ExchangeRate(
                    currency: key,
                    rate: String(format: "%.4f", value)
                )
            }
    }
}
