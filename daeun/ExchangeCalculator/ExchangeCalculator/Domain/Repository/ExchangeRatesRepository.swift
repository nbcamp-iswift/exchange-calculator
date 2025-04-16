//
//  ExchangeRatesRepository.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Alamofire
import Foundation

protocol ExchangeRatesRepository {
    func fetchExchangeRates(by currency: String) async -> Result<ExchangeRatesDTO, AFError>
}
