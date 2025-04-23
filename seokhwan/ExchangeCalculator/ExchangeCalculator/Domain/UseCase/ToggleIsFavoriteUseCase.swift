import Foundation

final class ToggleIsFavoriteUseCase {
    private let repository: ExchangeRateRepository

    init(exchangeRateRepository: ExchangeRateRepository) {
        repository = exchangeRateRepository
    }

    func execute(for currency: String) async -> Result<Void, ExchangeRateError> {
        await repository.toggleIsFavorite(for: currency)
    }
}
