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

    let networkManager = NetworkManager(service: ExchangeRateService())
    var disposeBag: DisposeBag = DisposeBag()

    var exchangeRates = BehaviorSubject<[ExchangeRate]>(value: [])
    var filteredExchangeRates = BehaviorSubject<[ExchangeRate]>(value: [])
    var errorSubject = BehaviorSubject<Error?>(value: nil)
    var searchBarText = BehaviorRelay<String>(value: "")

    init() {
        setbindings()
    }

    private func setbindings() {
        fetchExchangeRates()
        bindFilteredExchangeRates()
    }

    private func fetchExchangeRates() {
        networkManager.fetchExchangeRates()
            .subscribe { [weak self] result in
                guard let self else { return }

                switch result {
                case .success(let data):
                    self.exchangeRates.onNext(data)
                case .failure(let error):
                    self.errorSubject.onNext(error)
                }
            }
            .disposed(by: self.disposeBag)
    }

    private func bindFilteredExchangeRates() {
        Observable.combineLatest(searchBarText, exchangeRates)
            .map { searchbarText, exchangeRates in
                if searchbarText.isEmpty {
                    return exchangeRates
                } else {
                    return exchangeRates.filter {
                        $0.currenyCode.lowercased().contains(searchbarText.lowercased()) ||
                        $0.country.contains(searchbarText)
                    }
                }
            }
            .subscribe {
                self.filteredExchangeRates.onNext($0)
            }
            .disposed(by: self.disposeBag)
    }
}
