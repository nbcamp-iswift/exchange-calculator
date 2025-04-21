//
//  ListViewModel.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/17/25.
//

import Foundation
import Combine

final class ListViewModel: ViewModelProtocol {
    private let exchangeRatesUseCase: ExchangeRatesUseCase
    private var cancellables = Set<AnyCancellable>()
    var action = PassthroughSubject<Action, Never>()
    var state = State()

    enum Action {
        case viewDidLoad
        case didTapCell(Int)
        case didChangeSearchBarText(String)
        case didTapFavoriteButton(Int)
    }

    struct State {
        var originalRates: [ExchangeRate] = []
        let fetchError = PassthroughSubject<Void, Never>()
        var filteredRates = CurrentValueSubject<[ExchangeRate], Never>([])
        var hasMatches = CurrentValueSubject<Bool, Never>(true)
        let showDetailVC = PassthroughSubject<DetailViewController, Never>()
    }

    init(exchangeRatesUseCase: ExchangeRatesUseCase) {
        self.exchangeRatesUseCase = exchangeRatesUseCase
        bindActions()
    }

    private func bindActions() {
        action.sink { [weak self] action in
            switch action {
            case .viewDidLoad:
                self?.loadList()
            case .didTapCell(let row):
                self?.selectRate(at: row)
            case .didChangeSearchBarText(let text):
                self?.filterRates(with: text)
            case .didTapFavoriteButton(let row):
                // TODO: 리스트 재정렬, core data,
                print(row)
            }
        }
        .store(in: &cancellables)
    }

    private func loadList() {
        Task {
            let result = await exchangeRatesUseCase.execute()

            switch result {
            case let .success(data):
                state.originalRates = data
                state.filteredRates.send(state.originalRates)
            case .failure:
                state.fetchError.send(())
            }
        }
    }

    func filterRates(with searchQuery: String) {
        let filteredRates = searchQuery.isEmpty
            ? state.originalRates
            : state.originalRates.filter { $0.matches(query: searchQuery) }
        state.filteredRates.send(filteredRates)
        state.hasMatches.send(!state.filteredRates.value.isEmpty)
    }

    func selectRate(at row: Int) {
        let exchangeRate = state.filteredRates.value[row]
        let convertCurrencyUseCase = DefaultConvertCurrencyUseCase()
        let detailViewModel = DetailViewModel(
            exchangeRate: exchangeRate,
            convertCurrencyUseCase: convertCurrencyUseCase
        )
        let detailVC = DetailViewController(viewModel: detailViewModel)
        state.showDetailVC.send(detailVC)
    }
}
