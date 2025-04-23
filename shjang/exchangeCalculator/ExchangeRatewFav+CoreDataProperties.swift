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
    @NSManaged var rate: Double
    @NSManaged var lastUpdated: Int64
}

extension ExchangeRatewFav: Identifiable {}
