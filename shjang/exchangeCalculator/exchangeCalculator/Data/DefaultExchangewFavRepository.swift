import CoreData

final class DefaultExchangeRatewFavRepostitory: ExchangeRatewFavRepository {
    let coreDataStorage: CoreDataStorage

    init(coreDataStorage: CoreDataStorage) {
        self.coreDataStorage = coreDataStorage
    }

    func updateFavoriteStatus(currency: String, countryCode: String, isFavorite: Bool) {
        let context = coreDataStorage.taskContext()

        context.performAndWait {
            let request: NSFetchRequest<ExchangeRatewFav> = ExchangeRatewFav.fetchRequest()
            request.predicate = NSPredicate(
                format: "currency == %@ AND countryCode == %@", currency, countryCode
            )

            let existing = try? context.fetch(request).first

            if let item = existing {
                item.createdAt = Date()
                item.isFavorite = isFavorite
            } else if isFavorite {
                let entity = ExchangeRatewFav(context: context)
                entity.currency = currency
                entity.countryCode = countryCode
                entity.createdAt = Date()
                entity.isFavorite = true
            }

            do {
                try context.save()
            } catch {}
        }
    }

    func getFavorites() -> [ExchangeRatewFav] {
        let context = coreDataStorage.taskContext()
        let request: NSFetchRequest<ExchangeRatewFav> = ExchangeRatewFav.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == true")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        let result = (try? context.fetch(request)) ?? []
        return result
    }

    fileprivate func fetch(
        _ currency: String,
        _ countryCode: String,
        in context: NSManagedObjectContext
    ) -> ExchangeRatewFav? {
        let request: NSFetchRequest<ExchangeRatewFav> = ExchangeRatewFav.fetchRequest()
        request.predicate = NSPredicate(
            format: "currency == %@ AND countryCode == %@",
            currency,
            countryCode
        )
        return try? context.fetch(request).first
    }

    func removeAll() {
        let context = coreDataStorage.taskContext()
        let request = NSBatchDeleteRequest(fetchRequest: ExchangeRatewFav.fetchRequest())
        try? context.execute(request)
        try? context.save()
    }

    func count() -> Int? {
        let context = coreDataStorage.taskContext()
        let request: NSFetchRequest<ExchangeRatewFav> = ExchangeRatewFav.fetchRequest()
        return try? context.count(for: request)
    }
}
