//
//  LocalFavoriteDataSource.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/22/25.
//

import Foundation
import CoreData

final class LocalFavoriteDataSource {
    private var container: NSPersistentContainer?

    init(container: NSPersistentContainer) {
        self.container = container
    }

    func readAllData() -> [String: Bool] {
        guard let context = container?.viewContext else { return [:] }

        do {
            let results = try context.fetch(FavoriteExchange.fetchRequest())
            return Dictionary(uniqueKeysWithValues: results.map { ($0.code, true) })
        } catch {
            print("context read error")
        }

        return [:]
    }

    func updateData(for code: String) {
        guard let context = container?.viewContext else { return }

        let fetchRequest = FavoriteExchange.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "code == %@", code)

        do {
            let result = try context.fetch(fetchRequest)
            if let existing = result.first {
                context.delete(existing)
            } else {
                createData(for: code)
            }
            try context.save()
        } catch {
            print("update data error")
        }
    }

    private func createData(for code: String) {
        guard let context = container?.viewContext else { return }

        guard let entity = NSEntityDescription.entity(
            forEntityName: FavoriteExchange.className,
            in: context
        ) else { return }
        let newFavorite = NSManagedObject(entity: entity, insertInto: context)
        newFavorite.setValue(code, forKey: FavoriteExchange.Key.code)
    }
}
