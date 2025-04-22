//
//  ExchangeRateRepository.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/16/25.
//

import Foundation
import RxSwift

final class ExchangeRateRepository: ExchangeRateRepositoryProtocol {
    private let service: ServiceProtocol
    private let coreDataService: CoreDataService
    private let userDefaultsService: UserDefaultsService

    init(service: ServiceProtocol, coreDataService: CoreDataService) {
        self.service = service
        self.coreDataService = coreDataService
        userDefaultsService = UserDefaultsService()
    }

    func fetchExchangeRates() -> Single<[ExchangeRate]> {
        Single.create { [weak self] emitter in

            guard let self else {
                return Disposables.create()
            }

            Task {
                do {
                    // 최초 실행 시, API로 받은 lastUpdateTime이 없을 경우
                    if self.userDefaultsService.getLastUpdateTime() == 0 {
                        try await emitter(.success(self.fetchAndSaveLocalData()))
                    }
                    // 최초 실행이 아닐 시, API로 받은 lastUpdateTime이 있을 경우
                    else {
                        let lastUpdateDate = Date(
                            timeIntervalSince1970: TimeInterval(
                                self.userDefaultsService.getLastUpdateTime()
                            )
                        )
                        // 하루 지났을 때
                        if Date().timeIntervalSince(lastUpdateDate) >= 60 * 60 * 24 {
                            try await emitter(.success(self.updateLocalData()))
                        }
                        // 하루 안 지났을 때
                        else {
                            let localExchangeRates = try self.coreDataService.fetchData()
                            emitter(.success(localExchangeRates))
                        }
                    }
                } catch {
                    emitter(.failure(error))
                }
            }

            return Disposables.create()
        }
    }

    func updateBookmarkedExchangeRate(bookmarkedExchangeRate: ExchangeRate) -> Single<Void> {
        Single.create { [weak self] emitter in

            guard let self else {
                return Disposables.create()
            }

            do {
                try coreDataService.updateBookmark(
                    currencyCode: bookmarkedExchangeRate.currencyCode,
                    isBookmark: !bookmarkedExchangeRate.isBookmark
                )
                emitter(.success(()))
            } catch {
                emitter(.failure(error))
            }
            return Disposables.create()
        }
    }
}

extension ExchangeRateRepository {
    private func fetchAndSaveLocalData() async throws -> [ExchangeRate] {
        do {
            let responseData: ExchangeRateReponseDTO = try await service
                .request(ExchangeRateServiceType.fetchExchangeRate)

            userDefaultsService.setLastUpdateTime(
                lastUpdateTime: responseData.timeLastUpdateUnix
            )

            try coreDataService.saveExchangeRate(
                exchangeRates: responseData.toEntity()
            )

            return responseData.toEntity()
        } catch {
            throw error
        }
    }

    private func updateLocalData() async throws -> [ExchangeRate] {
        do {
            let responseData: ExchangeRateReponseDTO = try await service
                .request(ExchangeRateServiceType.fetchExchangeRate)

            var entities: [ExchangeRate] = responseData.toEntity()

            for index in 0 ..< entities.count {
                entities[index].isBookmark = try coreDataService.fetchBookmark(
                    currencyCode: entities[index].currencyCode
                )

                let newValue = Double(entities[index].value) ?? 0.0
                let oldValue = try Double(
                    coreDataService.fetchExchangeRateValue(
                        currencyCode: entities[index].currencyCode
                    )) ?? 0.0

                if abs(newValue - oldValue) > 0.01 {
                    entities[index].arrowState = newValue > oldValue ? .increase : .decrease
                } else {
                    entities[index].arrowState = .none
                }
            }

            try coreDataService.deleteAll()
            try coreDataService.saveExchangeRate(exchangeRates: entities)

            userDefaultsService.setLastUpdateTime(
                lastUpdateTime: responseData.timeLastUpdateUnix
            )

            return entities
        } catch {
            throw error
        }
    }
}
