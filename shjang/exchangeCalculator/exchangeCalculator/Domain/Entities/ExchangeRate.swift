import Foundation

public struct ExchangeRate: Hashable {
    let currency: String
    let country: String
    let rate: String
    let timeLastUpdated: Int
}
