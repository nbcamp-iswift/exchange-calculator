import Foundation
import Alamofire

final class ExchangeRateService {
    func fetchExchangeRateInfo(
        for currency: String
    ) async -> Result<ExchangeRateInfoDTO, AFError> {
        let url = "https://open.er-api.com/v6/latest/\(currency)"
        let result = await AF.request(url).serializingDecodable(ExchangeRateInfoDTO.self).result

        return result
    }
}
