//
//  ConvertError.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/21/25.
//

import Foundation

enum ConvertError: Error {
    case emptyInput
    case invalidNumberFormat

    var errorDescription: String {
        switch self {
        case .emptyInput:
            return "금액을 입력해주세요"
        case .invalidNumberFormat:
            return "올바른 숫자를 입력해주세요"
        }
    }
}
