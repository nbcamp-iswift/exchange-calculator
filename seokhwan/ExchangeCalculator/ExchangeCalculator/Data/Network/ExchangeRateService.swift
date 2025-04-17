import Foundation
import Alamofire

final class ExchangeRateService {
    func fetchExchangeRateInfo(
        for currency: String
    ) async -> Result<ExchangeRateInfoDTO, ExchangeRateError> {
        let url = "https://open.er-api.com/v6/latest/\(currency)"
        let result = await AF.request(url).serializingDecodable(ExchangeRateInfoDTO.self).result

        switch result {
        case .success(let dto):
            return .success(dto)
        case .failure(let error):
            return .failure(.unknownError)
        }
    }
}
