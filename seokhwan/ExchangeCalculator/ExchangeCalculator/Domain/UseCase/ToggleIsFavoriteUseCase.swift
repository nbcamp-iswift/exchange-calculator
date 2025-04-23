import Foundation

final class ToggleIsFavoriteUseCase {
    private let repository: ExchangeRateRepositoryProtocol

    init(exchangeRateRepository: ExchangeRateRepositoryProtocol) {
        repository = exchangeRateRepository
    }

    func execute(for currency: String) async -> Result<Void, ExchangeRateError> {
        await repository.toggleIsFavorite(for: currency)
    }
}
