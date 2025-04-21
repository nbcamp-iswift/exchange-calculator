import Foundation

struct ExchangeRateInfoDTO: Codable {
    let timeLastUpdateUnix: TimeInterval
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case timeLastUpdateUnix = "time_last_update_unix"
        case rates
    }
}
