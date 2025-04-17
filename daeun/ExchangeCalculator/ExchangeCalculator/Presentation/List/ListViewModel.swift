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
    @Published private(set) var hasMatches: Bool = true

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

    func filterRates(with searchQuery: String) {
        if searchQuery.isEmpty {
            filteredRates = originalRates
        } else {
            filteredRates = originalRates.filter { $0.code.hasPrefix(searchQuery.uppercased()) }
            hasMatches = !filteredRates.isEmpty
        }
    }
}
