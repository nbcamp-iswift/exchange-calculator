//
//  FavoriteExchange+CoreDataClass.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/22/25.
//
//

import Foundation
import CoreData

@objc(FavoriteExchange)
public class FavoriteExchange: NSManagedObject {
    static let className = "FavoriteExchange"

    enum Key {
        static let code = "code"
    }
}
