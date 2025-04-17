//
//  ListViewModel.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/17/25.
//

import Foundation

final class ListViewModel {
    private let exchangeRatesUseCase: ExchangeRatesUseCase
    @Published private(set) var rates: [ExchangeRate] = []
    @Published private(set) var error: Bool = false

    init(exchangeRatesUseCase: ExchangeRatesUseCase) {
        self.exchangeRatesUseCase = exchangeRatesUseCase
    }

    func loadItems() {
        Task {
            let result = await exchangeRatesUseCase.execute()

            switch result {
            case let .success(data):
                self.rates = data
            case .failure:
                error = true
            }
        }
    }
}
