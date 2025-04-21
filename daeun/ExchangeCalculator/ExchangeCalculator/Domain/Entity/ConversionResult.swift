//
//  ConversionResult.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/21/25.
//

import Foundation

enum ConversionResult {
    case success(inputAmount: Double, converted: Double)
    case failure(ConvertError)
}
