import Foundation

final class ExchangeRateUseCase {
    let repository: ExchangeRateRepository

    private let defaultCurrency = "USD"

    init(exchangeRateRepository: ExchangeRateRepository) {
        repository = exchangeRateRepository
    }

    func fetchExchangeRates(
        for currency: String?
    ) async -> Result<ExchangeRateInfo, ExchangeRateError> {
        await repository.fetchExchangeRates(for: currency ?? defaultCurrency)
    }
}
