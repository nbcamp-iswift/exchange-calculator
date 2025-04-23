import Foundation

final class FetchExchangeRateUseCase {
    private let repository: ExchangeRateRepositoryProtocol

    init(exchangeRateRepository: ExchangeRateRepositoryProtocol) {
        repository = exchangeRateRepository
    }

    func execute() async -> Result<ExchangeRateInfo, ExchangeRateError> {
        await repository.fetchExchangeRates()
    }
}
