import Foundation
import CoreData

@objc(LastScreen)
public class LastScreenEntity: NSManagedObject {
    @NSManaged var name: String
    @NSManaged var exchangeRate: ExchangeRateEntity?
}
