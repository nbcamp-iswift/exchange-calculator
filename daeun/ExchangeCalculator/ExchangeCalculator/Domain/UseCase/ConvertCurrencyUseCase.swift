//
//  ConvertCurrencyUseCase.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/21/25.
//

import Foundation

enum ConvertError: Error {
    case emptyInput
    case invalidNumberFormat
}

protocol ConvertCurrencyUseCase {
    func execute(
        amount: String?,
        with rate: ExchangeRate
    ) -> Result<ConversionResult, ConvertError>
}

final class DefaultConvertCurrencyUseCase: ConvertCurrencyUseCase {
    func execute(
        amount: String?,
        with rate: ExchangeRate
    ) -> Result<ConversionResult, ConvertError> {
        guard let text = amount else {
            return .failure(.emptyInput)
        }
        guard let amountValue = Double(text) else {
            return .failure(.invalidNumberFormat)
        }

        let converted = rate.value * amountValue
        let conversionResult = ConversionResult(inputAmount: amountValue, converted: converted)
        return .success(conversionResult)
    }
}
