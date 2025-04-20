//
//  Double+Extensions.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/17/25.
//

import Foundation

extension Double {
    func roundedTo(digits: Int) -> Double {
        let multiplier = 10 * Double(digits)
        return (self * multiplier).rounded() / multiplier
    }
}
