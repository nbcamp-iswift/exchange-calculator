import CoreData

final class ExchangeRateStorage {
    static let shared = ExchangeRateStorage()

    private let container: NSPersistentContainer

    private var context: NSManagedObjectContext {
        container.viewContext
    }

    private init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("CoreData Error: \(error.localizedDescription)")
            }
        }
    }

    func fetchAll() async -> Result<ExchangeRateEntities, ExchangeRateError> {
        await context.perform { [weak self] in
            let request = ExchangeRateEntity.fetchRequest()
            guard let entities = try? self?.context.fetch(request) as? ExchangeRateEntities else {
                return .failure(.favoriteUpdateFailed)
            }

            return .success(entities)
        }
    }

    func updateOldValues(with rates: [String: Double]) async -> Result<Void, ExchangeRateError> {
        await context.perform { [weak self] in
            let request = ExchangeRateEntity.fetchRequest() as? NSFetchRequest<ExchangeRateEntity>
            guard let request,
                  let context = self?.context,
                  let entities = try? context.fetch(request) else {
                return .failure(.dataSaveFailed)
            }

            for entity in entities {
                guard let oldValue = rates[entity.currency] else { continue }
                entity.oldValue = oldValue
            }

            do {
                try context.save()
                return .success(())
            } catch {
                return .failure(.dataSaveFailed)
            }
        }
    }

    func toggleIsFavorite(for currency: String) async -> Result<Void, ExchangeRateError> {
        await context.perform { [weak self] in
            let request = ExchangeRateEntity.fetchRequest() as? NSFetchRequest<ExchangeRateEntity>
            request?.predicate = NSPredicate(format: "currency == %@", currency)
            request?.fetchLimit = 1

            guard let request,
                  let context = self?.context,
                  let results = try? context.fetch(request) else {
                return .failure(.favoriteUpdateFailed)
            }

            let entity: ExchangeRateEntity
            if let result = results.first {
                entity = result
                entity.isFavorite.toggle()
            } else {
                entity = ExchangeRateEntity(context: context)
                entity.currency = currency
                entity.isFavorite = true
            }

            do {
                try context.save()
                return .success(())
            } catch {
                return .failure(.favoriteUpdateFailed)
            }
        }
    }
}
