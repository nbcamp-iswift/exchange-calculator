import Foundation

struct CachedExchangeRate {
    let currency: String
    let countryCode: String
    let rate: Double
    let lastUpdated: Int64
    let isFavorite: Bool
}
