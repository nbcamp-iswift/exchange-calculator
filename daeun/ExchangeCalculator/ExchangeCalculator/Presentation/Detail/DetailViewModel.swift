//
//  DetailViewModel.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/19/25.
//

import Foundation
import Combine

final class DetailViewModel {
    let exchangeRate = CurrentValueSubject<ExchangeRate?, Never>(nil)

    init(exchangeRate: ExchangeRate) {
        self.exchangeRate.value = exchangeRate
    }
}
