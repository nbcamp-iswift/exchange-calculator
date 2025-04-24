//
//  Double+Extensions.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/17/25.
//

import Foundation

extension Double {
    func roundedTo(digits: Int) -> Double {
        let multiplier: Double = Array(repeating: 10, count: digits).reduce(1, *)
        return (self * multiplier).rounded() / multiplier
    }
}
