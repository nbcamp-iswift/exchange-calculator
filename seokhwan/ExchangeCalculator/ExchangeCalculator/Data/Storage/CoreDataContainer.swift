import Foundation
import CoreData

final class CoreDataContainer {
    static let shared = CoreDataContainer()

    private let container: NSPersistentContainer

    var context: NSManagedObjectContext {
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
}
