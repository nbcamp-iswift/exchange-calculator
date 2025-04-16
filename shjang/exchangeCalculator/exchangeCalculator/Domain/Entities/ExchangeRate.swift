import Foundation

struct ExchangeRate: Codable {
    let currency: String
    let country: String
    let rate: Double
}
