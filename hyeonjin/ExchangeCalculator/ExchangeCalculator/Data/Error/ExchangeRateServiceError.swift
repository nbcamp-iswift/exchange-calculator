//
//  ExchangeRateServiceError.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/16/25.
//

import Foundation

enum ExchangeRateServiceError: Error {
    case invaildURL
    case statusCodeError(Int)
    case decodingError(Error)
}
