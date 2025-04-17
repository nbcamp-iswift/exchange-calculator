//
//  ReuseIdentifying.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Foundation

protocol ReuseIdentifying {
    static var reuseIdentifier: String { get }
}

extension ReuseIdentifying {
    static var reuseIdentifier: String {
        String(describing: self)
    }
}
