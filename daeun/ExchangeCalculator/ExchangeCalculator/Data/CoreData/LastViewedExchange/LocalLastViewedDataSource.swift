//
//  LocalLastViewedDataSource.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/23/25.
//

import Foundation
import CoreData

final class LocalLastViewedDataSource {
    private var container: NSPersistentContainer?

    init(container: NSPersistentContainer) {
        self.container = container
    }

    func readData() -> String? {
        guard let context = container?.viewContext else { return nil }
        let request = LastViewedExchange.fetchRequest()
        request.fetchLimit = 1

        guard let lastViewed = try? context.fetch(request).first else { return nil }
        return lastViewed.code
    }

    func addData(code: String) {
        guard let context = container?.viewContext else { return }
        guard let entity = NSEntityDescription.entity(
            forEntityName: LastViewedExchange.className,
            in: context
        ) else { return }

        let newObject = LastViewedExchange(entity: entity, insertInto: context)
        newObject.code = code

        try? context.save()
    }

    func deleteData() {
        guard let context = container?.viewContext,
              let result = try? context.fetch(LastViewedExchange.fetchRequest()) else { return }

        for data in result as [NSManagedObject] {
            context.delete(data)
        }

        try? context.save()
    }
}
