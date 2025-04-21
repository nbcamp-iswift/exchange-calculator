import Foundation

struct ExchangeRateDto: Codable {
    let baseCode: String // "USD"
    let rates: [String: Double]
    let timeLastUpdated: Int

    enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case rates
        case timeLastUpdated = "time_last_update_unix"
    }
}

enum ExchangeRateMapper {
    static func map(
        dto: ExchangeRateDto,
        using mapper: (String) -> String = CurrencyNameMapper.name
    ) -> [ExchangeRate] {
        let lastTimeUpdated = dto.timeLastUpdated
        return dto.rates
            .sorted { $0.key < $1.key }
            .map { key, value in
                ExchangeRate(
                    currency: key,
                    country: mapper(key),
                    rate: String(format: "%.4f", value),
                    timeLastUpdated: lastTimeUpdated
                )
            }
    }
}
