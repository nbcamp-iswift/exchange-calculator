import Foundation

final class ExchangeRateRepository {
    let service: ExchangeRateService

    // TODO: fetch한 데이터를 저장하고 있어야함
    // TODO: Mapper를 Repository로 가져와서(최소 Data Layer로 가져와서) 여기서 매핑
    // TODO: Mapping 후 Presentation Layer에서 Mapper 참조 제거

    init(exchangeRateService: ExchangeRateService) {
        service = exchangeRateService
    }

    func fetchExchangeRates(
        for currency: String
    ) async -> Result<ExchangeRateInfo, ExchangeRateError> {
        let result = await service.fetchExchangeRateInfo(for: currency)

        switch result {
        case .success(let dto):
            return .success(ExchangeRateInfo(from: dto))
        case .failure(let error):
            return .failure(error)
        }
    }
}
