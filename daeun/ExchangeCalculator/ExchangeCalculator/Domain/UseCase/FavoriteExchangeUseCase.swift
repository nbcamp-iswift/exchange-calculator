//
//  FavoriteExchangeUseCase.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/22/25.
//

import Foundation

protocol FavoriteExchangeUseCase {
    func toggleFavorite(for code: String)
}

struct DefaultFavoriteExchangeUseCase: FavoriteExchangeUseCase {
    let repository: DefaultFavoriteExchangeRepository

    func toggleFavorite(for code: String) {
        repository.toggleFavorite(for: code)
    }
}
