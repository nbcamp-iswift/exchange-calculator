import Foundation

final class ExchangeRateRepository {
    let service: ExchangeRateService
    let storage: ExchangeRateStorage

    init(exchangeRateService: ExchangeRateService, exchangeRateStorage: ExchangeRateStorage) {
        service = exchangeRateService
        storage = exchangeRateStorage
    }

    func fetchExchangeRates() async -> Result<ExchangeRateInfo, ExchangeRateError> {
        let result = await service.fetchExchangeRateInfo()

        switch result {
        case .success(let dto):
            guard case .success = await updateOldValue(from: dto) else {
                return .failure(.dataSaveFailed)
            }

            let countries = CurrencyCountryMapper.countries(for: Array(dto.rates.keys))
            let result = await storage.fetchAll()

            switch result {
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

    private func updateOldValue(
        from dto: ExchangeRateInfoDTO
    ) async -> Result<Void, ExchangeRateError> {
        let lastUpdate = UserDefaults.standard.double(forKey: "timeLastUpdateUnix")

        if lastUpdate == 0.0 { // 최초 실행 시 Mock 데이터 Insert
            if case .success = await storage.insertMockEntitiesIfNeeded() {
                return .success(())
            } else {
                return .failure(.dataSaveFailed)
            }
        }

        guard dto.timeLastUpdateUnix > lastUpdate else { return .success(()) }
        let result = await storage.updateOldValues(with: dto.rates)

        switch result {
        case .success:
            UserDefaults.standard.set(dto.timeLastUpdateUnix, forKey: "timeLastUpdateUnix")
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
                let entity = entities.first { $0.currency == currency }

                return ExchangeRate(
                    currency: currency,
                    country: country,
                    value: value,
                    oldValue: entity?.oldValue ?? 0.0,
                    isFavorite: entity?.isFavorite ?? false
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
