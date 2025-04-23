//
//  LastViewedExchange+CoreDataClass.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/23/25.
//
//

import Foundation
import CoreData

@objc(LastViewedExchange)
public class LastViewedExchange: NSManagedObject {
    static let className = "LastViewedExchange"

    enum Key {
        static let code = "code"
    }
}
