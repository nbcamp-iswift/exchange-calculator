//
//  DefaultFavoriteExchangeRepository.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/22/25.
//

import Foundation

struct DefaultFavoriteExchangeRepository: FavoriteExchangeRepository {
    private let localDataSource: LocalFavoriteDataSource

    init(localDataSource: LocalFavoriteDataSource) {
        self.localDataSource = localDataSource
    }

    func toggleFavorite(for code: String) {
        localDataSource.updateData(for: code)
    }
}
