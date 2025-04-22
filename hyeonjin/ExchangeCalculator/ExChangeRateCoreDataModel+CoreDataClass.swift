//
//  ExChangeRateCoreDataModel+CoreDataClass.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/21/25.
//
//

import Foundation
import CoreData

@objc(ExChangeRateCoreDataModel)
public class ExChangeRateCoreDataModel: NSManagedObject {
    public static let className = "ExChangeRateCoreDataModel"
    public enum Key {
        static let value = "value"
        static let currencyCode = "currencyCode"
        static let isBookmark = "isBookmark"
        static let country = "country"
    }
}
