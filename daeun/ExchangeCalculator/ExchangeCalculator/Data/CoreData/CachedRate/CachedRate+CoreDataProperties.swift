//
//  CachedRate+CoreDataProperties.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/22/25.
//
//

import Foundation
import CoreData

public extension CachedRate {
    @nonobjc class func fetchRequest() -> NSFetchRequest<CachedRate> {
        NSFetchRequest<CachedRate>(entityName: "CachedRate")
    }

    @NSManaged var code: String
    @NSManaged var lastValue: Double
    @NSManaged var currValue: Double
    @NSManaged var lastUpdated: Date
}

extension CachedRate: Identifiable {}
