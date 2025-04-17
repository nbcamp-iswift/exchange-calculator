//
//  ListViewModel.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/17/25.
//

import Foundation

final class ListViewModel {
    private let exchangeRatesUseCase: ExchangeRatesUseCase
    private var originalRates: [ExchangeRate] = []
    @Published private(set) var error: Bool = false
    @Published private(set) var filteredRates: [ExchangeRate] = []

    init(exchangeRatesUseCase: ExchangeRatesUseCase) {
        self.exchangeRatesUseCase = exchangeRatesUseCase
        loadList()
    }

    private func loadList() {
        Task {
            let result = await exchangeRatesUseCase.execute()

            switch result {
            case let .success(data):
                originalRates = data
                filteredRates = originalRates
            case .failure:
                error = true
            }
        }
    }
}
