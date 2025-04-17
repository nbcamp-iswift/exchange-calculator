//
//  ListViewModel.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/17/25.
//

import Foundation
import os

final class ListViewModel {
    private let useCase: ExchangeRatesUseCase
    @Published private(set) var rates: [ExchangeRate] = []

    init(useCase: ExchangeRatesUseCase) {
        self.useCase = useCase
    }

    func loadItems() {
        Task {
            let result = await useCase.fetchExchangeRates(of: Constant.baseCurrency)

            switch result {
            case let .success(data):
                self.rates = data.rates
            case .failure:
                os_log("Show Alert")
            }
        }
    }
}
