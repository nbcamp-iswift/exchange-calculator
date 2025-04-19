//
//  ListViewModel.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/17/25.
//

import Foundation
import Combine

final class ListViewModel {
    private let exchangeRatesUseCase: ExchangeRatesUseCase
    private var originalRates: [ExchangeRate] = []
    @Published private(set) var error: Bool = false
    @Published private(set) var filteredRates: [ExchangeRate] = []
    @Published private(set) var hasMatches: Bool = true
    let showDetailVC = PassthroughSubject<DetailViewController, Never>()

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
            : originalRates.filter { $0.matches(query: searchQuery) }
        hasMatches = !filteredRates.isEmpty
    }

    func selectRate(at row: Int) {
        let exchangeRate = filteredRates[row]
        let detailViewModel = DetailViewModel(exchangeRate: exchangeRate)
        let detailVC = DetailViewController(viewModel: detailViewModel)
        showDetailVC.send(detailVC)
    }
}
