//
//  ListViewModel.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/17/25.
//

import Foundation

final class ListViewModel {
    private let exchangeRatesUseCase: ExchangeRatesUseCase
    private let countryCodeMapper = CountryCodeMapper()
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
        filteredRates = searchQuery.isEmpty
        ? originalRates
        : originalRates.filter { matchesQuery($0, query: searchQuery) }

        hasMatches = !filteredRates.isEmpty
    }

    func countryName(for code: String) -> String {
        countryCodeMapper.name(for: code)
    }

    private func matchesQuery(_ rate: ExchangeRate, query: String) -> Bool {
        let countryCode = rate.code
        let countryName = countryCodeMapper.name(for: rate.code)

        return countryCode.hasPrefix(query.uppercased()) || countryName.hasPrefix(query)
    }
}
