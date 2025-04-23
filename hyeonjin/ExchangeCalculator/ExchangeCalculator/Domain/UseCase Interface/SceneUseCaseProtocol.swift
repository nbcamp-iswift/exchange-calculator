//
//  SceneUseCaseProtocol.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/23/25.
//

import Foundation

protocol SceneUseCaseProtocol {
    func loadScene() throws -> (exchangeRate: ExchangeRate, isEmptyScene: Bool)
    func saveScene(exchangeRate: ExchangeRate, isEmptyScene: Bool) throws
}
