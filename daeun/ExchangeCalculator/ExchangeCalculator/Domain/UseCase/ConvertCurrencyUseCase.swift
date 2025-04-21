//
//  ConvertCurrencyUseCase.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/21/25.
//

import Foundation

protocol ConvertCurrencyUseCase {
    func execute(amount: String?, with rate: ExchangeRate) -> ConversionResult
}

final class DefaultConvertCurrencyUseCase: ConvertCurrencyUseCase {
    func execute(amount: String?, with rate: ExchangeRate) -> ConversionResult {
        guard let text = amount, !text.isEmpty else {
            return .failure(.emptyInput)
        }
        guard let amountValue = Double(text) else {
            return .failure(.invalidNumberFormat)
        }

        let converted = rate.value * amountValue
        return .success(inputAmount: amountValue, converted: converted)
    }
}
