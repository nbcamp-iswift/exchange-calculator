import CoreData

final class DefaultAppStateStore: AppStateStore {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func saveLastScreen(type: LastScreenType, selectedCurrency: String?) {
        context.performAndWait {
            let request: NSFetchRequest<AppStates> = AppStates.fetchRequest()
            let object = (try? context.fetch(request))?.first ?? AppStates(context: context)
            object.lastScreen = type.rawValue
            object.selectedCurrency = selectedCurrency
            object.updatedAt = Date()
            try? context.save()
        }
    }

    func loadLastScreen() -> LastScreenInfo {
        let result: LastScreenInfo = context.performAndWait {
            let request: NSFetchRequest<AppStates> = AppStates.fetchRequest()
            guard let object = try? context.fetch(request).first else {
                return LastScreenInfo(screen: .table, selectedCurrency: nil)
            }

            let screenType = LastScreenType(rawValue: object.lastScreen ?? "") ?? .table

            return LastScreenInfo(
                screen: screenType,
                selectedCurrency: object.selectedCurrency
            )
        }

        return result
    }
}
