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

    init(service: ServiceProtocol, coreDataService: CoreDataService) {
        self.service = service
        self.coreDataService = coreDataService
    }

    func fetchExchangeRates() -> Single<[ExchangeRate]> {
        Single.create { [weak self] emitter in

            guard let self else {
                return Disposables.create()
            }

            Task {
                do {
                    let responseData: ExchangeRateReponseDTO = try await self.service
                        .request(ExchangeRateServiceType.fetchExchangeRate)
                    emitter(.success(responseData.toEntity()))
                } catch {
                    emitter(.failure(error))
                }
            }

            return Disposables.create()
        }
    }
}
