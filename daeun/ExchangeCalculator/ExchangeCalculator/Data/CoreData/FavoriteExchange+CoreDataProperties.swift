//
//  FavoriteExchange+CoreDataProperties.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/22/25.
//
//

import Foundation
import CoreData

public extension FavoriteExchange {
    @nonobjc class func fetchRequest() -> NSFetchRequest<FavoriteExchange> {
        NSFetchRequest<FavoriteExchange>(entityName: "FavoriteExchange")
    }

    @NSManaged var code: String?
}

extension FavoriteExchange: Identifiable {}
