//
//  MainViewModel.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/15/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel {
    var disposeBag: DisposeBag = .init()

    let exchangeUseCase: ExchangeRateUseCaseProtocol

    var originalExchangeRates = BehaviorSubject<[ExchangeRate]>(value: [])
    var filteredExchangeRates = BehaviorSubject<[ExchangeRate]>(value: [])
    var errorSubject = BehaviorSubject<Error?>(value: nil)
    var searchBarText = BehaviorRelay<String>(value: "")

    init(exchangeUseCase: ExchangeRateUseCaseProtocol) {
        self.exchangeUseCase = exchangeUseCase
        setBindings()
    }

    private func setBindings() {
        fetchExchangeRates()
        bindFilteredExchangeRates()
    }

    private func fetchExchangeRates() {
        exchangeUseCase.fetchExchangeRates()
            .subscribe { [weak self] result in
                guard let self else { return }

                switch result {
                case .success(let data):
                    originalExchangeRates.onNext(data)
                case .failure(let error):
                    errorSubject.onNext(error)
                }
            }
            .disposed(by: disposeBag)
    }

    private func bindFilteredExchangeRates() {
        Observable.combineLatest(searchBarText, originalExchangeRates)
            .map { searchbarText, exchangeRates in
                if searchbarText.isEmpty {
                    return exchangeRates
                } else {
                    return exchangeRates.filter {
                        $0.currencyCode.lowercased().contains(searchbarText.lowercased()) ||
                            $0.country.contains(searchbarText)
                    }
                }
            }
            .subscribe {
                self.filteredExchangeRates.onNext($0)
            }
            .disposed(by: disposeBag)
    }
}
