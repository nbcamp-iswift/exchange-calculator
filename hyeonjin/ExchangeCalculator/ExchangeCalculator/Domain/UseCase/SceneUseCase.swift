//
//  SceneUseCase.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/23/25.
//

import Foundation

final class SceneUseCase: SceneUseCaseProtocol {
    let repository: SceneRepositoryProtocol

    init(repository: SceneRepositoryProtocol) {
        self.repository = repository
    }

    func saveScene(exchangeRate: ExchangeRate, isEmptyScene: Bool) throws {
        try repository.saveScene(exchangeRate: exchangeRate, isEmptyScene: isEmptyScene)
    }

    func loadScene() throws -> (exchangeRate: ExchangeRate, isEmptyScene: Bool) {
        do {
            let latestScene = try repository.loadScene()
            return latestScene
        } catch CoreDataError.noMatch {
            // 초기 실행 시, CoreData에 load할 데이터가 없는 상황
            // dummy 저장
            let dummy = ExchangeRate.dummyEntity
            try repository.saveScene(exchangeRate: dummy, isEmptyScene: true)
            return try repository.loadScene()
        }
    }
}
