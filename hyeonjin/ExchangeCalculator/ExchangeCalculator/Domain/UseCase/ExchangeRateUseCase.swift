//
//  ExchangeRateUseCase.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/20/25.
//

import Foundation
import RxSwift

final class ExchangeRateUseCase: ExchangeRateUseCaseProtocol {
    let repository: ExchangeRateRepositoryProtocol

    init(repository: ExchangeRateRepositoryProtocol) {
        self.repository = repository
    }

    func fetchExchangeRates() -> Observable<[ExchangeRate]> {
        repository.fetchExchangeRates().asObservable()
    }

    func filterExchangeRates(
        text: String,
        originalExchangeRates: [ExchangeRate]
    ) -> [ExchangeRate] {
        text.isEmpty
            ? originalExchangeRates
            : originalExchangeRates.filter {
                $0.currencyCode.lowercased().contains(text.lowercased()) ||
                    $0.country.contains(text)
            }
    }
    func updateBookmarkedExchangeRate(bookmarkedExchangeRate: ExchangeRate) -> Observable<Void> {
        repository.updateBookmarkedExchangeRate(
            bookmarkedExchangeRate: bookmarkedExchangeRate
        ).asObservable()
    }
}
