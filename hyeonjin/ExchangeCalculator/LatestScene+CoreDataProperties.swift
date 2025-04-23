//
//  LatestScene+CoreDataProperties.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/23/25.
//
//

import Foundation
import CoreData

public extension LatestScene {
    @nonobjc class func fetchRequest() -> NSFetchRequest<LatestScene> {
        NSFetchRequest<LatestScene>(entityName: "LatestScene")
    }

    @NSManaged var isEmptyScene: Bool
    @NSManaged var relationship: ExChangeRateCoreDataModel?
}

extension LatestScene: Identifiable {}
