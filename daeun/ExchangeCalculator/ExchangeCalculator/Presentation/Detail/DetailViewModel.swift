//
//  DetailViewModel.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/19/25.
//

import Foundation
import Combine

final class DetailViewModel {
    let convertCurrencyUseCase: ConvertCurrencyUseCase
    let exchangeRate = CurrentValueSubject<ExchangeRate?, Never>(nil)
    let convertedResultText = PassthroughSubject<String, Never>()
    let inputError = PassthroughSubject<Void, Never>()
    let invalidNumberFormatError = PassthroughSubject<Void, Never>()

    init(exchangeRate: ExchangeRate, convertCurrencyUseCase: ConvertCurrencyUseCase) {
        self.exchangeRate.value = exchangeRate
        self.convertCurrencyUseCase = convertCurrencyUseCase
    }

    func convert(amount: String?) {
        guard let rate = exchangeRate.value else { return }
        let result = convertCurrencyUseCase.execute(amount: amount, with: rate)

        switch result {
        case .success(let result):
            let baseSymbol = CurrencyCodeMapper.symbol(for: Constant.baseCurrency)
            let formattedInput = String(format: "%.2f", result.inputAmount)
            let formattedOutput = String(format: "%.2f", result.converted)
            let targetCode = rate.currencyCode

            let displayText = "\(baseSymbol)\(formattedInput) ⇨ \(formattedOutput)\(targetCode)"
            convertedResultText.send(displayText)
        case .failure(let error):
            switch error {
            case .emptyInput:
                inputError.send(())
            case .invalidNumberFormat:
                invalidNumberFormatError.send(())
            }
        }
    }
}
