import Foundation

struct ExchangeRateDto: Codable {
    let baseCode: String // "USD"
    let rates: [String: Double]
}
