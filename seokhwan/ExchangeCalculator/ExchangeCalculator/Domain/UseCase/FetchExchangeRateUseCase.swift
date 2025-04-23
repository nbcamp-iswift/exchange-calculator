import Foundation

final class FetchExchangeRateUseCase {
    private let repository: ExchangeRateRepository

    init(exchangeRateRepository: ExchangeRateRepository) {
        repository = exchangeRateRepository
    }

    func execute() async -> Result<ExchangeRateInfo, ExchangeRateError> {
        await repository.fetchExchangeRates()
    }
}
