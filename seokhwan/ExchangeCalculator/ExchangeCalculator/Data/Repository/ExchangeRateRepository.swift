import Foundation

final class ExchangeRateRepository {
    let service: ExchangeRateService
    let storage: ExchangeRateStorage

    init(exchangeRateService: ExchangeRateService, exchangeRateStorage: ExchangeRateStorage) {
        service = exchangeRateService
        storage = exchangeRateStorage
    }

    func fetchExchangeRates() async -> Result<ExchangeRateInfo, ExchangeRateError> {
        let serviceResult = await service.fetchExchangeRateInfo()

        switch serviceResult {
        case .success(let dto):
            let countries = CurrencyCountryMapper.countries(for: Array(dto.rates.keys))
            let storageResult = await storage.fetchAll()

            switch storageResult {
            case .success(let entities):
                let result = makeExchangeRateInfo(
                    dto: dto,
                    countries: countries,
                    entities: entities
                )
                return .success(result)
            case .failure(let error):
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }

    func toggleIsFavorite(for currency: String) async -> Result<Void, ExchangeRateError> {
        let result = await storage.toggleIsFavorite(for: currency)

        switch result {
        case .success:
            return .success(())
        case .failure(let error):
            return .failure(error)
        }
    }

    private func makeExchangeRateInfo(
        dto: ExchangeRateInfoDTO,
        countries: [String: String],
        entities: ExchangeRateEntities
    ) -> ExchangeRateInfo {
        let exchangeRates = dto.rates
            .map { currency, value in
                let country = countries[currency] ?? "-"
                let isFavorite = entities.first { $0.currency == currency }?.isFavorite ?? false

                return ExchangeRate(
                    currency: currency,
                    country: country,
                    value: value,
                    isFavorite: isFavorite
                )
            }
            .sorted {
                if $0.isFavorite == $1.isFavorite {
                    return $0.currency < $1.currency
                } else {
                    return $0.isFavorite && !$1.isFavorite
                }
            }

        return ExchangeRateInfo(
            lastUpdated: Date(timeIntervalSince1970: dto.timeLastUpdateUnix),
            exchangeRates: exchangeRates
        )
    }
}
