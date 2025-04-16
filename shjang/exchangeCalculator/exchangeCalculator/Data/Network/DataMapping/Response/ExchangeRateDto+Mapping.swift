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
    func toDomain() -> [ExchangeRate] {
        rates.map { ExchangeRate(currency: $0.key, rate: $0.value) }
    }
}
