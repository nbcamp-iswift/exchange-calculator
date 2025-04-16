//
//  DefaultExchangeRatesRepository.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Alamofire
import Foundation

struct DefaultExchangeRatesRepository: ExchangeRatesRepository {
    func fetchExchangeRates(by currency: String) async -> Result<ExchangeRatesDTO, AFError> {
        let url = Constant.baseURL + currency
        let result = await AF.request(url).serializingDecodable(ExchangeRatesDTO.self).result

        return result
    }
}
