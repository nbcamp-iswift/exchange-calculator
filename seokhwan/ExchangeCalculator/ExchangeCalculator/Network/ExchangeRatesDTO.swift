import Foundation

struct ExchangeRatesDTO: Codable {
    let lastUpdated: TimeInterval
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case lastUpdated = "time_last_update_unix"
        case rates
    }
}
