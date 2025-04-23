//
//  ExchangeRatesRepository.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Alamofire
import Foundation

protocol ExchangeRatesRepository {
    func fetchExchangeRates() async -> Result<[ExchangeRate], AFError>
    func saveLastViewedExchangeRate(code: String)
    func deleteLastViewedExchangeRate()
}
