//
//  DefaultExchangeRatesRepository.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Alamofire
import Foundation

struct DefaultExchangeRatesRepository: ExchangeRatesRepository {
    func fetchExchangeRates() async -> Result<[ExchangeRate], AFError> {
        let url = Constant.baseURL + Constant.baseCurrency
        let result = await AF.request(url).serializingDecodable(ExchangeRatesDTO.self).result
        return result.map { $0.toEntity() }
    }
}
