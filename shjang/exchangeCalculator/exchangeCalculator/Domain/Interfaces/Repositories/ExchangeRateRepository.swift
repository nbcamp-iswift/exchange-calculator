import Combine
import Foundation

protocol ExchangeRateRepository {
    func fetch(
        baseCurrency: String,
        completion: @escaping (Result<[ExchangeRate], Error>) -> Void
    ) -> Cancellable?
}
