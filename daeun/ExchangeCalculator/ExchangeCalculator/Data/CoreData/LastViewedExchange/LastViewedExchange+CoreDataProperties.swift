//
//  LastViewedExchange+CoreDataProperties.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/23/25.
//
//

import Foundation
import CoreData

public extension LastViewedExchange {
    @nonobjc class func fetchRequest() -> NSFetchRequest<LastViewedExchange> {
        NSFetchRequest<LastViewedExchange>(entityName: "LastViewedExchange")
    }

    @NSManaged var code: String
    @NSManaged var rate: Double
}

extension LastViewedExchange: Identifiable {}
