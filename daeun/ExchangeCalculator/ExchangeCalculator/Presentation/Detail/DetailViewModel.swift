//
//  DetailViewModel.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/19/25.
//

import Foundation
import Combine

final class DetailViewModel: ViewModelProtocol {
    private let convertCurrencyUseCase: ConvertCurrencyUseCase
    private var exchangeRatesUseCase: ExchangeRatesUseCase?
    private var cancellables = Set<AnyCancellable>()
    var action = PassthroughSubject<Action, Never>()
    let state = State()

    enum Action {
        case didTapConvertButton(String?)
    }

    struct State {
        let exchangeRate = CurrentValueSubject<ExchangeRate?, Never>(nil)
        let convertedResultText = PassthroughSubject<String, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
    }

    init(exchangeRate: ExchangeRate, convertCurrencyUseCase: ConvertCurrencyUseCase) {
        state.exchangeRate.send(exchangeRate)
        self.convertCurrencyUseCase = convertCurrencyUseCase
        bindActions()
    }

    init(
        code: String,
        convertCurrencyUseCase: ConvertCurrencyUseCase,
        exchangeRatesUseCase: ExchangeRatesUseCase
    ) {
        self.convertCurrencyUseCase = convertCurrencyUseCase
        self.exchangeRatesUseCase = exchangeRatesUseCase
        findItem(with: code)
        bindActions()
    }

    private func bindActions() {
        action.sink { [weak self] action in
            switch action {
            case let .didTapConvertButton(text):
                self?.convert(amount: text)
            }
        }
        .store(in: &cancellables)
    }

    private func findItem(with code: String) {
        Task {
            guard let result = await exchangeRatesUseCase?.loadList() else { return }
            switch result {
            case let .success(list):
                let exchangeRate = list.first { $0.currencyCode == code }
                state.exchangeRate.send(exchangeRate)
            case let .failure(error):
                print("failed to fetch list: \(error)")
            }
        }
    }

    private func convert(amount: String?) {
        guard let rate = state.exchangeRate.value else { return }
        let result = convertCurrencyUseCase.execute(amount: amount, with: rate)

        switch result {
        case .success(let inputAmount, let converted):
            let baseSymbol = CurrencyCodeMapper.symbol(for: Constant.baseCurrency)
            let formattedInput = String(format: "%.2f", inputAmount)
            let formattedOutput = String(format: "%.2f", converted)
            let targetCode = rate.currencyCode

            let displayText = "\(baseSymbol)\(formattedInput) → \(formattedOutput) \(targetCode)"
            state.convertedResultText.send(displayText)
        case .failure(let error):
            state.errorMessage.send(error.errorDescription)
        }
    }
}
