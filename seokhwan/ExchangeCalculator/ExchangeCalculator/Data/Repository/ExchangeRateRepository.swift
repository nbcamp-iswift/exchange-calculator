import Foundation

final class ExchangeRateRepository {
    let service: ExchangeRateService

    init(exchangeRateService: ExchangeRateService) {
        service = exchangeRateService
    }

    func fetchExchangeRates() async -> Result<ExchangeRateInfo, ExchangeRateError> {
        let result = await service.fetchExchangeRateInfo()

        switch result {
        case .success(let dto):
            let countries = CurrencyCountryMapper.countries(for: Array(dto.rates.keys))
            return .success(dto.toEntity(with: countries))
        case .failure(let error):
            return .failure(error)
        }
    }
}
