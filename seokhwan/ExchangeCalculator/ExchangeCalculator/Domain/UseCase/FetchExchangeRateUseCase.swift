import Foundation

final class FetchExchangeRateUseCase {
    let repository: ExchangeRateRepository

    private let defaultCurrency = "USD"

    init(exchangeRateRepository: ExchangeRateRepository) {
        repository = exchangeRateRepository
    }

    func execute(for currency: String?) async -> Result<ExchangeRateInfo, ExchangeRateError> {
        await repository.fetchExchangeRates(for: currency ?? defaultCurrency)
    }
}
