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
    var action: ((Action) -> Void)?
    let state = State()

    enum Action {
        case didTapConvertButton(String?)
    }

    struct State {
        let exchangeRate = CurrentValueSubject<ExchangeRate?, Never>(nil)
        let convertedResultText = PassthroughSubject<String, Never>()
        let inputError = PassthroughSubject<Void, Never>()
        let invalidNumberFormatError = PassthroughSubject<Void, Never>()
    }

    init(exchangeRate: ExchangeRate, convertCurrencyUseCase: ConvertCurrencyUseCase) {
        state.exchangeRate.send(exchangeRate)
        self.convertCurrencyUseCase = convertCurrencyUseCase
        bindActions()
    }

    private func bindActions() {
        action = { [weak self] action in
            switch action {
            case let .didTapConvertButton(text):
                self?.convert(amount: text)
            }
        }
    }

    private func convert(amount: String?) {
        guard let rate = state.exchangeRate.value else { return }
        let result = convertCurrencyUseCase.execute(amount: amount, with: rate)

        switch result {
        case .success(let result):
            let baseSymbol = CurrencyCodeMapper.symbol(for: Constant.baseCurrency)
            let formattedInput = String(format: "%.2f", result.inputAmount)
            let formattedOutput = String(format: "%.2f", result.converted)
            let targetCode = rate.currencyCode

            let displayText = "\(baseSymbol)\(formattedInput) → \(formattedOutput) \(targetCode)"
            state.convertedResultText.send(displayText)
        case .failure(let error):
            switch error {
            case .emptyInput:
                state.inputError.send(())
            case .invalidNumberFormat:
                state.invalidNumberFormatError.send(())
            }
        }
    }
}
