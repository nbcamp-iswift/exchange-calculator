//
//  CoreDataService.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/21/25.
//

import Foundation
import CoreData

final class CoreDataService {
    var context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func fetchData() throws -> [ExchangeRate] {
        let fetchRequest = NSFetchRequest<ExChangeRateCoreDataModel>(
            entityName: "ExChangeRateCoreDataModel"
        )

        do {
            let exchangeRates = try context.fetch(fetchRequest) as [ExChangeRateCoreDataModel]

            return exchangeRates.map {
                ExchangeRate(
                    currencyCode: $0.currencyCode ?? "",
                    value: $0.value ?? "",
                    country: $0.country ?? "",
                    isBookmark: $0.isBookmark,
                    arrowState: ArrowState(rawValue: $0.arrowState ?? "") ?? .none
                )
            }
        } catch {
            throw CoreDataError.fetchFailed
        }
    }

    func saveExchangeRate(exchangeRates: [ExchangeRate]) throws {
        guard let entity = NSEntityDescription.entity(
            forEntityName: "ExChangeRateCoreDataModel",
            in: context
        ) else { throw CoreDataError.unknownEntity }

        exchangeRates.forEach {
            let object = NSManagedObject(entity: entity, insertInto: context)
            object.setValue($0.value, forKey: "value")
            object.setValue($0.currencyCode, forKey: "currencyCode")
            object.setValue($0.country, forKey: "country")
            object.setValue($0.isBookmark, forKey: "isBookmark")
            object.setValue($0.arrowState.rawValue, forKey: "arrowState")
        }

        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }

    func fetchExchangeRateValue(currencyCode: String) throws -> String {
        let fetchRequest = NSFetchRequest<ExChangeRateCoreDataModel>(
            entityName: "ExChangeRateCoreDataModel"
        )
        fetchRequest.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)

        do {
            guard let result = try? context.fetch(fetchRequest),
                  let object = result.first else { throw CoreDataError.fetchFailed }
            return object.value ?? "0"
        } catch {
            throw CoreDataError.fetchFailed
        }
    }

    func updateBookmark(currencyCode: String, isBookmark: Bool) throws {
        let fetchRequest = NSFetchRequest<ExChangeRateCoreDataModel>(
            entityName: "ExChangeRateCoreDataModel"
        )
        fetchRequest.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)

        do {
            guard let result = try? context.fetch(fetchRequest) else {
                throw CoreDataError.fetchFailed
            }
            guard let object = result.first else { throw CoreDataError.noMatch }
            object.setValue(isBookmark, forKey: "isBookmark")
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }

    func fetchBookmark(currencyCode: String) throws -> Bool {
        let fetchRequest = NSFetchRequest<ExChangeRateCoreDataModel>(
            entityName: "ExChangeRateCoreDataModel"
        )
        fetchRequest.predicate = NSPredicate(format: "currencyCode == %@", currencyCode)

        do {
            let result = try context.fetch(fetchRequest)
            guard let object = result.first else { throw CoreDataError.noMatch }
            return object.isBookmark
        } catch {
            throw CoreDataError.fetchFailed
        }
    }

    func deleteAll() throws {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(
            entityName: "ExChangeRateCoreDataModel"
        )
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(deleteRequest)
        } catch {
            throw CoreDataError.deleteFailed
        }
    }

    func saveLatestScene(exchangeRate: ExchangeRate, value: Bool) throws {
        let existingScenes = try context.fetch(NSFetchRequest<LatestScene>(
            entityName: "LatestScene")
        )
        for scene in existingScenes {
            context.delete(scene)
        }

        guard let entity = NSEntityDescription.insertNewObject(
            forEntityName: "LatestScene",
            into: context
        ) as? LatestScene else { throw CoreDataError.unknownEntity }

        let fetchRequest = NSFetchRequest<ExChangeRateCoreDataModel>(
            entityName: "ExChangeRateCoreDataModel"
        )
        fetchRequest.predicate = NSPredicate(
            format: "currencyCode == %@", exchangeRate.currencyCode
        )

        guard let exchangeRateObject = try context.fetch(fetchRequest).first else {
            throw CoreDataError.noMatch
        }

        entity.relationship = exchangeRateObject
        entity.isEmptyScene = value

        do {
            try context.save()
        } catch {
            throw CoreDataError.saveFailed
        }
    }

    func fetchSuccessedLatestScene() throws -> LatestScene {
        let fetchRequest = NSFetchRequest<LatestScene>(entityName: "LatestScene")
        guard let fetchLatestScene = try context.fetch(fetchRequest).first else {
            throw CoreDataError.noMatch
        }
        return fetchLatestScene
    }
}
