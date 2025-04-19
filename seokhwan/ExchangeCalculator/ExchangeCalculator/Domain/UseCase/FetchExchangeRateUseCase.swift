import Foundation

final class FetchExchangeRateUseCase {
    let repository: ExchangeRateRepository

    init(exchangeRateRepository: ExchangeRateRepository) {
        repository = exchangeRateRepository
    }

    func execute() async -> Result<ExchangeRateInfo, ExchangeRateError> {
        await repository.fetchExchangeRates()
    }
}
