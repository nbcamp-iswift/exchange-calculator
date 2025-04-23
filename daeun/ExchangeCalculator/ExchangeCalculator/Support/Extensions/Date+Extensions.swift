//
//  Date+Extensions.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/22/25.
//

import Foundation

extension Date {
    func isAfterOneDay(comparedTo other: Date, calendar: Calendar = .current) -> Bool {
        let startSelf = calendar.startOfDay(for: self)
        let startOther = calendar.startOfDay(for: other)

        let components = calendar.dateComponents([.day], from: startOther, to: startSelf)
        guard let dayDiff = components.day else { return false }

        return dayDiff > 0
    }
}
