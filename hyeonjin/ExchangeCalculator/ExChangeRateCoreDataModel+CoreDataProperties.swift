//
//  ExChangeRateCoreDataModel+CoreDataProperties.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/22/25.
//
//

import Foundation
import CoreData

public extension ExChangeRateCoreDataModel {
    @nonobjc class func fetchRequest() -> NSFetchRequest<ExChangeRateCoreDataModel> {
        NSFetchRequest<ExChangeRateCoreDataModel>(entityName: "ExChangeRateCoreDataModel")
    }

    @NSManaged var country: String?
    @NSManaged var currencyCode: String?
    @NSManaged var isBookmark: Bool
    @NSManaged var value: String?
    @NSManaged var arrowState: String?
}

extension ExChangeRateCoreDataModel: Identifiable {}
