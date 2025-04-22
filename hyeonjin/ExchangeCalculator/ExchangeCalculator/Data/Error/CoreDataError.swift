//
//  CoreDataError.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/21/25.
//

import Foundation

enum CoreDataError: Error {
    case fetchFailed
    case unknownEntity
    case saveFailed
    case noMatch
    case deleteFailed
}
