//
//  SceneRepository.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/23/25.
//

import Foundation

final class SceneRepository: SceneRepositoryProtocol {
    let coreDataService: CoreDataService

    init(coreDataService: CoreDataService) {
        self.coreDataService = coreDataService
    }

    func saveScene(exchangeRate: ExchangeRate, isEmptyScene: Bool) throws {
        try coreDataService.saveLatestScene(exchangeRate: exchangeRate, value: isEmptyScene)
    }

    func loadScene() throws -> (exchangeRate: ExchangeRate, isEmptyScene: Bool) {
        let latestScene = try coreDataService.fetchSuccessedLatestScene()
        let relationship = latestScene.relationship
        let exchangeRate = ExchangeRate(
            currencyCode: relationship?.currencyCode ?? "",
            value: relationship?.value ?? "0",
            country: relationship?.country ?? "",
            isBookmark: false,
            arrowState: .none
        )
        return (exchangeRate, latestScene.isEmptyScene)
    }
}
