import Foundation

final class ExchangeRateRepository {
    let service: ExchangeRateService

    // TODO: fetch한 데이터를 저장하고 있어야함

    init(exchangeRateService: ExchangeRateService) {
        service = exchangeRateService
    }

    func fetchExchangeRates(
        for currency: String
    ) async -> Result<ExchangeRateInfo, ExchangeRateError> {
        let result = await service.fetchExchangeRateInfo(for: currency)

        switch result {
        case .success(let dto):
            let countries = CurrencyCountryMapper.countries(for: Array(dto.rates.keys))
            return .success(ExchangeRateInfo(from: dto, with: countries))
        case .failure(let error):
            return .failure(error)
        }
    }
}
