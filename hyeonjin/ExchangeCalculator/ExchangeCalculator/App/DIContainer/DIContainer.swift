//
//  DIContainer.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/20/25.
//

import Foundation
import UIKit
import CoreData

final class DIContainer: DIContainerProtocol {
    private let context: NSManagedObjectContext

    init(context: NSManagedObjectContext) {
        self.context = context
    }

    func makeMainViewModel() -> MainViewModel {
        let repository = ExchangeRateRepository(
            service: ExchangeRateService(),
            coreDataService: CoreDataService(context: context)
        )
        let useCase = ExchangeRateUseCase(repository: repository)
        return MainViewModel(exchangeUseCase: useCase)
    }

    func makeSceneUseCase() -> SceneUseCase {
        let repository = SceneRepository(
            coreDataService: CoreDataService(context: context)
        )
        return SceneUseCase(repository: repository)
    }
}
