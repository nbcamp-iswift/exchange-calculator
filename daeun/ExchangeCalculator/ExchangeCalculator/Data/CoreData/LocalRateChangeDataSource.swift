//
//  LocalRateChangeDataSource.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/22/25.
//

import Foundation
import CoreData

final class LocalRateChangeDataSource {
    private var container: NSPersistentContainer?

    init(container: NSPersistentContainer) {
        self.container = container
    }

    func readAllData() -> [String: Double] {
        guard let context = container?.viewContext else { return [:] }
        do {
            let results = try context.fetch(CachedRate.fetchRequest())
            return .init(uniqueKeysWithValues: results.map { ($0.code ?? "", $0.lastValue) })
        } catch {
            print("context read error: \(error)")
        }
        return [:]
    }

    func readLastUpdatedDate() -> Date? {
        guard let context = container?.viewContext else { return nil }
        do {
            let results = try context.fetch(CachedRate.fetchRequest())
            return results.first?.lastUpdated
        } catch {}

        return nil
    }

    func updateData(to rates: [String: Double], on currentDate: Date) {
        guard let context = container?.viewContext else { return }
        let request = CachedRate.fetchRequest()
        do {
            let existing = try context.fetch(request)
            let existingMap = Dictionary(
                uniqueKeysWithValues: existing.map { ($0.code ?? "", $0) }
            )

            guard let entity = NSEntityDescription.entity(
                forEntityName: CachedRate.className,
                in: context
            ) else { return }

            for (code, value) in rates {
                if let object = existingMap[code] {
                    object.lastValue = value
                    object.lastUpdated = currentDate
                } else {
                    let newObject = CachedRate(entity: entity, insertInto: context)
                    newObject.code = code
                    newObject.lastValue = value.roundedTo(digits: Constant.Digits.rate)
                    newObject.lastUpdated = currentDate
                }
            }

            try context.save()
        } catch {
            print("updateData error: \(error)")
        }
    }
}
