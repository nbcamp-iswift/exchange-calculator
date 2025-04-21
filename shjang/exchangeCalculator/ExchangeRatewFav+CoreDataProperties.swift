//
//  ExchangeRatewFav+CoreDataProperties.swift
//  exchangeCalculator
//
//  Created by SeunghoJang on 4/21/25.
//
//

import Foundation
import CoreData

public extension ExchangeRatewFav {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ExchangeRatewFav> {
        NSFetchRequest<ExchangeRatewFav>(entityName: "ExchangeRatewFav")
    }

    @NSManaged var countryCode: String
    @NSManaged var createdAt: Date
    @NSManaged var currency: String
    @NSManaged var isFavorite: Bool
}

extension ExchangeRatewFav: Identifiable {}
