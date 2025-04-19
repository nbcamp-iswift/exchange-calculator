import Foundation

struct ExchangeRateInfoDTO: Codable {
    let baseCode: String
    let timeLastUpdateUnix: TimeInterval
    let rates: [String: Double]

    enum CodingKeys: String, CodingKey {
        case baseCode = "base_code"
        case timeLastUpdateUnix = "time_last_update_unix"
        case rates
    }
}
