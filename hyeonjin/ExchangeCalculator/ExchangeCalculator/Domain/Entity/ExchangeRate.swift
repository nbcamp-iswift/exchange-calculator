//
//  ExchangeRate.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/16/25.
//

import Foundation

enum ArrowState: String {
    case increase
    case decrease
    case none
}

struct ExchangeRate: Hashable {
    let currencyCode: String
    let value: String
    let country: String
    var isBookmark: Bool
    var arrowState: ArrowState

    static var dummyEntity: ExchangeRate {
        ExchangeRate(
            currencyCode: "USD",
            value: "0",
            country: "미국",
            isBookmark: false,
            arrowState: .none
        )
    }
}
