//
//  ExchangeRateRepositoryProtocol.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/20/25.
//

import Foundation
import RxSwift

protocol ExchangeRateRepositoryProtocol {
    func fetchExchangeRates() -> Single<[ExchangeRate]>
    func updateBookmarkedExchangeRate(bookmarkedExchangeRate: ExchangeRate) -> Single<Void>
}
