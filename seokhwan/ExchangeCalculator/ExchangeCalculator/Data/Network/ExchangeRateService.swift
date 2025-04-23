import Foundation
import Alamofire

final class ExchangeRateService {
    func fetchExchangeRateInfo() async -> Result<ExchangeRateInfoDTO, ExchangeRateError> {
        let url = "https://open.er-api.com/v6/latest/USD" // TODO: Endpoint 은닉
        let result = await AF.request(url).serializingDecodable(ExchangeRateInfoDTO.self).result

        switch result {
        case .success(let dto):
            return .success(dto)
        case .failure: // TODO: Network Error 구체화
            return .failure(.networkError)
        }
    }
}
