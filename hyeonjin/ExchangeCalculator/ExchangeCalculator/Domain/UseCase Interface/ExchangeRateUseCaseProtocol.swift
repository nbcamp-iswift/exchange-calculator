//
//  ExchangeRateUseCaseProtocol.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/20/25.
//

import Foundation
import RxSwift

protocol ExchangeRateUseCaseProtocol {
    func fetchExchangeRates() -> Observable<[ExchangeRate]>
    func filterExchangeRates(
        text: String,
        originalExchangeRates: [ExchangeRate]
    ) -> [ExchangeRate]
}
