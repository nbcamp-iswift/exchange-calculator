import Foundation
import CoreData

@objc(LastScreen)
public class LastScreenEntity: NSManagedObject {
    @NSManaged var rawValue: String
}
