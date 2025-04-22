//
//  UserDefaultsService.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/22/25.
//

import Foundation

final class UserDefaultsService {
    func getLastUpdateTime() -> Int {
        UserDefaults.standard.integer(forKey: "lastUpdateTime")
    }

    func setLastUpdateTime(lastUpdateTime: Int) {
        UserDefaults.standard.set(lastUpdateTime, forKey: "lastUpdateTime")
    }
}
