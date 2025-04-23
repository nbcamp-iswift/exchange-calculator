import CoreData

final class DefaultCoreDataRepostitory: CoreDataStackProtocol {
    let coreDataStack: CoreDataStack

    init(coreDataStack: CoreDataStack) {
        self.coreDataStack = coreDataStack
    }

    func loadCachedRates() -> [String: Double] {
        let context = coreDataStack.taskContext()
        let request = ExchangeRatewFav.fetchRequest()
        let result = (try? context.fetch(request)) ?? []

        var map: [String: Double] = [:]
        for item in result {
            map[item.currency] = item.rate
        }
        return map
    }

    func saveOrUpdate(rate: ExchangeRate, isFavorite: Bool) {
        let context = coreDataStack.taskContext()
        context.performAndWait {
            let request: NSFetchRequest<ExchangeRatewFav> = ExchangeRatewFav.fetchRequest()
            request.predicate = NSPredicate(
                format: "currency == %@ AND countryCode == %@",
                rate.currency,
                rate.country
            )

            let object = (try? context.fetch(request))?.first ?? ExchangeRatewFav(context: context)
            object.currency = rate.currency
            object.countryCode = rate.country
            object.rate = Double(rate.rate) ?? 0.0
            object.createdAt = Date()
            object.isFavorite = isFavorite
            object.lastUpdated = Int64(rate.timeLastUpdated)
            try? context.save()
        }
    }

    func updateFavoriteStatus(currency: String, countryCode: String, isFavorite: Bool) {
        let context = coreDataStack.taskContext()

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
                entity.isFavorite = isFavorite
            }

            do {
                try context.save()
            } catch {}
        }
    }

    func getAllExchangedRate() -> [ExchangeRatewFav] {
        let context = coreDataStack.taskContext()
        let request: NSFetchRequest<ExchangeRatewFav> = ExchangeRatewFav.fetchRequest()
        guard let result = try? context.fetch(request) else { return [] }
        return result
    }

    func getFavorites() -> [ExchangeRatewFav] {
        let context = coreDataStack.taskContext()
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
        let context = coreDataStack.taskContext()
        let request = NSBatchDeleteRequest(fetchRequest: ExchangeRatewFav.fetchRequest())
        try? context.execute(request)
        try? context.save()
    }

    func count() -> Int? {
        let context = coreDataStack.taskContext()
        let request: NSFetchRequest<ExchangeRatewFav> = ExchangeRatewFav.fetchRequest()
        return try? context.count(for: request)
    }
}
