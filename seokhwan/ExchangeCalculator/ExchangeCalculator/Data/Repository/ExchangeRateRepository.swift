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
            // TODO: favorite 값 fetch한 뒤, 합쳐서 toEntity() 호출
            // TODO: DTO의 toEntity 로직도 이 쪽으로 가지고 오기

            return .success(dto.toEntity(with: countries))
        case .failure(let error):
            return .failure(error)
        }
    }

    func toggleIsFavorite(for currency: String) async -> Result<Void, ExchangeRateError> {
        print("currency: \(currency)") // TODO: CoreData에 접근해서 값 업데이트
        return .success(()) // TODO: 임시 return (구현 후 삭제)
    }
}
