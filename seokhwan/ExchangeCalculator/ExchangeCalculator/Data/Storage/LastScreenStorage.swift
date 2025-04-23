import CoreData

final class LastScreenStorage {
    private var context: NSManagedObjectContext {
        CoreDataContainer.shared.context
    }

    // 마지막으로 본 화면 fetch
    func fetch() async -> LastScreenEntity? {
        await context.perform { [weak self] in
            let request = LastScreenEntity.fetchRequest() as? NSFetchRequest<LastScreenEntity>
            guard let request,
                  let context = self?.context,
                  let entity = try? context.fetch(request).first else {
                return nil
            }

            return entity
        }
    }

    // 마지막으로 본 화면 update
    func updateLastScreen(to name: String, with exchangeRate: ExchangeRate?) async {
        await context.perform { [weak self] in
            let request = LastScreenEntity.fetchRequest() as? NSFetchRequest<LastScreenEntity>
            request?.fetchLimit = 1

            guard let request,
                  let context = self?.context else { return }

            // 기존에 저장된 데이터가 있다면 삭제
            if let existing = try? context.fetch(request).first {
                context.delete(existing)
            }

            var exchangeRateEntity: ExchangeRateEntity?
            if let exchangeRate {
                exchangeRateEntity = ExchangeRateEntity(context: context)
                exchangeRateEntity?.currency = exchangeRate.currency
                exchangeRateEntity?.oldValue = exchangeRate.oldValue
                exchangeRateEntity?.isFavorite = exchangeRate.isFavorite
            }

            let lastScreenEntity = LastScreenEntity(context: context)
            lastScreenEntity.name = name
            lastScreenEntity.exchangeRate = exchangeRateEntity

            try? context.save()
        }
    }
}
