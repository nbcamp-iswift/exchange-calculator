import Foundation

final class ExchangeRateRepository: ExchangeRateRepositoryProtocol {
    private let service: ExchangeRateService
    private let storage: ExchangeRateStorage

    init(exchangeRateService: ExchangeRateService, exchangeRateStorage: ExchangeRateStorage) {
        service = exchangeRateService
        storage = exchangeRateStorage
    }

    func fetchExchangeRates() async -> Result<ExchangeRateInfo, ExchangeRateError> {
        // API에서 DTO Fetch
        let result = await service.fetchExchangeRateInfo()

        switch result {
        case .success(let dto):
            // OldValue 업데이트
            guard case .success = await updateOldValue(from: dto) else {
                return .failure(.storageError)
            }

            // 국가명 매핑
            let countries = CurrencyCountryMapper.countries(for: Array(dto.rates.keys))
            // CoreData에서 Entity Fetch
            let result = await storage.fetchAll()

            switch result {
            case .success(let entities):
                // Network와 Storage에서 Fetch한 데이터를 Merge하여 Domain Model init
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

    // 즐겨찾기 상태 토글
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

        // 최초 실행 시 Mock 데이터 Insert
        if lastUpdate == 0.0 {
            if case .success = await storage.insertMockEntitiesIfNeeded() {
                return .success(())
            } else {
                return .failure(.storageError)
            }
        }

        // API에서 Fetch한 데이터가 최신 데이터일 경우만 아래 로직 실행
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

    // Network와 Storage에서 Fetch한 데이터를 Merge하여 Domain Model init하는 메서드
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
                    return $0.currency < $1.currency // 즐겨찾기 상태가 같으면 사전순 정렬
                } else {
                    return $0.isFavorite && !$1.isFavorite // isFavorite가 true인 요소를 앞으로 정렬
                }
            }

        return ExchangeRateInfo(
            lastUpdated: Date(timeIntervalSince1970: dto.timeLastUpdateUnix),
            exchangeRates: exchangeRates
        )
    }
}
