import CoreData

enum StoreType {
    case persistent, inMemory
    func nsStoreType() -> String {
        switch self {
        case .persistent:
            return NSSQLiteStoreType
        case .inMemory:
            return NSInMemoryStoreType
        }
    }
}

// CoreDataStack
final class CoreDataStack {
    static let shared = CoreDataStack(storeType: .persistent)
    private let storeType: StoreType

    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "ExchangeRatewFav")

        if self.storeType == .inMemory {
            let description = NSPersistentStoreDescription()
            description.type = NSInMemoryStoreType
            container.persistentStoreDescriptions = [description]
        }

        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }

        // inMemory First
        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        container.viewContext.shouldDeleteInaccessibleFaults = true
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()

    var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    init(storeType: StoreType) {
        self.storeType = storeType
    }

    private func setBackgroundContext(_ context: NSManagedObjectContext) {
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        context.undoManager = nil
    }

    func taskContext() -> NSManagedObjectContext {
        let taskContext = persistentContainer.newBackgroundContext()
        setBackgroundContext(taskContext)
        return taskContext
    }

    func performBackgroundTask(task: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask { context in
            self.setBackgroundContext(context)
            task(context)
        }
    }
}
