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
        let sortedOriginalExchangeRates = originalExchangeRates.sorted {
            if $0.isBookmark != $1.isBookmark {
                return $0.isBookmark && !$1.isBookmark
            } else {
                return $0.currencyCode < $1.currencyCode
            }
        }
        return text.isEmpty
            ? sortedOriginalExchangeRates
            : sortedOriginalExchangeRates
                .filter {
                    $0.currencyCode.lowercased().contains(text.lowercased()) ||
                        $0.country.contains(text)
                }
    }

    func bookmarkExchangeRate(
        bookmarkedExchangeRate: ExchangeRate,
        originalExchangeRates: [ExchangeRate]
    ) -> [ExchangeRate] {
        var originalExchangeRates = originalExchangeRates

        if let index = originalExchangeRates.firstIndex(of: bookmarkedExchangeRate) {
            originalExchangeRates[index].isBookmark.toggle()
        }

        return originalExchangeRates.sorted {
            if $0.isBookmark != $1.isBookmark {
                return $0.isBookmark && !$1.isBookmark
            } else {
                return $0.currencyCode < $1.currencyCode
            }
        }
    }

    func updateBookmarkedExchangeRate(bookmarkedExchangeRate: ExchangeRate) -> Observable<Void> {
        repository.updateBookmarkedExchangeRate(
            bookmarkedExchangeRate: bookmarkedExchangeRate
        ).asObservable()
    }
}
