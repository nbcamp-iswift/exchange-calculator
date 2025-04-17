//
//  NetworkManager.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/16/25.
//

import Foundation
import RxSwift

final class NetworkManager {
    private let service: ServiceProtocol

    init(service: ServiceProtocol) {
        self.service = service
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
