import Combine
import Foundation

// DataService Protocol
protocol ExchangeRateRepository {
    func fetch(
        baseCurrency: String,
        completion: @escaping (Result<[ExchangeRate], Error>) -> Void
    )
}
