//
//  MainViewModel.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/15/25.
//

import Foundation
import RxSwift

final class MainViewModel {

    let networkManager = NetworkManager()

    var disposeBag: DisposeBag = DisposeBag()

    var exchangeRates = BehaviorSubject<[ExchangeRate]>(value: [])

    var errorSubject = BehaviorSubject<Error?>(value: nil)

    init() {
        fetchExchangeRates()
    }

    func fetchExchangeRates() {
        networkManager.fetchExchangeRates()
            .subscribe { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let data):
                    self.exchangeRates.onNext(data)
                case .failure(let error):
                    self.errorSubject.onNext(error)
                }

            }.disposed(by: self.disposeBag)
    }
}
