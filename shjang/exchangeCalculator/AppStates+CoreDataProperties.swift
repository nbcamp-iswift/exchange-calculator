//
//  AppStates+CoreDataProperties.swift
//  exchangeCalculator
//
//  Created by SeunghoJang on 4/23/25.
//
//

import Foundation
import CoreData

public extension AppStates {
    @nonobjc class func fetchRequest() -> NSFetchRequest<AppStates> {
        NSFetchRequest<AppStates>(entityName: "AppStates")
    }

    @NSManaged var lastScreen: String?
    @NSManaged var updatedAt: Date?
    @NSManaged var selectedCurrency: String?
}

extension AppStates: Identifiable {}
