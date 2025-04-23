import Foundation
import CoreData

typealias ExchangeRateEntities = [ExchangeRateEntity]

@objc(ExchangeRate)
public class ExchangeRateEntity: NSManagedObject {
    @NSManaged var currency: String
    @NSManaged var oldValue: Double
    @NSManaged var isFavorite: Bool
}
