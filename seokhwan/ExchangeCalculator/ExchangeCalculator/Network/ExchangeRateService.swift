import Foundation
import Alamofire

final class ExchangeRateService {
    func fetchExchangeRates(for currency: String) async -> Result<ExchangeRatesDTO, AFError> {
        let url = "https://open.er-api.com/v6/latest/\(currency)"
        let result = await AF.request(url).serializingDecodable(ExchangeRatesDTO.self).result

        return result
    }
}
