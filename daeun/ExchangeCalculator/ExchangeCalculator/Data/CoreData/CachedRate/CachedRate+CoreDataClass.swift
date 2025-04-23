//
//  CachedRate+CoreDataClass.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/22/25.
//
//

import Foundation
import CoreData

@objc(CachedRate)
public class CachedRate: NSManagedObject {
    static let className = "CachedRate"

    enum Key {
        static let code = "code"
        static let lastValue = "lastValue"
        static let lastUpdated = "lastUpdated"
    }
}
