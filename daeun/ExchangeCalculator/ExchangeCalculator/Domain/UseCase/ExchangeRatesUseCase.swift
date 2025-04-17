//
//  ExchangeRatesUseCase.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Alamofire
import Foundation

protocol ExchangeRatesUseCase {
    func fetchExchangeRates(of baseCurrency: String) async -> Result<ExchangeRates, AFError>
}
