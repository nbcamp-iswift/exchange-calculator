//
//  FavoriteExchangeRepository.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/22/25.
//

import Foundation

protocol FavoriteExchangeRepository {
    func toggleFavorite(for code: String)
}
