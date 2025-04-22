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
                return .failure(.storageError)
            }

            return .success(entities)
        }
    }

    // 최초 실행 시, Mock Data 삽입
    func insertMockEntitiesIfNeeded() async -> Result<Void, ExchangeRateError> {
        await context.perform { [weak self] in
            let request = ExchangeRateEntity.fetchRequest() as? NSFetchRequest<ExchangeRateEntity>
            request?.fetchLimit = 1

            guard let request,
                  let context = self?.context else {
                return .failure(.storageError)
            }
            let entityCount = (try? context.count(for: request)) ?? 0
            guard entityCount == 0 else { return .success(()) }

            let mocks = MockDataProvider().data

            for mock in mocks {
                let entity = ExchangeRateEntity(context: context)
                entity.currency = mock.key
                entity.oldValue = mock.value
                entity.isFavorite = false
            }

            do {
                try context.save()
                return .success(())
            } catch {
                return .failure(.storageError)
            }
        }
    }

    // CoreData Entity의 OldValue를 업데이트하는 메서드
    func updateOldValues(with rates: [String: Double]) async -> Result<Void, ExchangeRateError> {
        await context.perform { [weak self] in
            let request = ExchangeRateEntity.fetchRequest() as? NSFetchRequest<ExchangeRateEntity>
            guard let request,
                  let context = self?.context,
                  let entities = try? context.fetch(request) else {
                return .failure(.storageError)
            }

            for entity in entities {
                guard let oldValue = rates[entity.currency] else { continue }
                entity.oldValue = oldValue
            }

            do {
                try context.save()
                return .success(())
            } catch {
                return .failure(.storageError)
            }
        }
    }

    // 즐겨찾기 상태 토글
    func toggleIsFavorite(for currency: String) async -> Result<Void, ExchangeRateError> {
        await context.perform { [weak self] in
            let request = ExchangeRateEntity.fetchRequest() as? NSFetchRequest<ExchangeRateEntity>
            request?.predicate = NSPredicate(format: "currency == %@", currency)
            request?.fetchLimit = 1

            guard let request,
                  let context = self?.context,
                  let results = try? context.fetch(request) else {
                return .failure(.storageError)
            }

            if let entity = results.first {
                entity.isFavorite.toggle()
            }

            do {
                try context.save()
                return .success(())
            } catch {
                return .failure(.storageError)
            }
        }
    }
}
