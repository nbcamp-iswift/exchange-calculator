//
//  ExchangeRate.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Foundation

struct ExchangeRate: Hashable {
    let currencyCode: String
    let countryName: String
    let value: Double

    func matches(query: String) -> Bool {
        currencyCode.contains(query.uppercased()) || countryName.contains(query)
    }
}
