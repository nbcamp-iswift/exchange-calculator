//
//  ExchangeRate.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/16/25.
//

import Foundation

struct ExchangeRate: Hashable {
    let currencyCode: String
    let value: String
    let country: String
}
