//
//  MainViewModel.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/15/25.
//

import Foundation
import RxSwift
import RxCocoa

final class MainViewModel: ViewModelProtocol {
    enum Action {
        case fetchExchangeRates
        case updateSearchBarText(String)
        case filterExchangeRates([ExchangeRate])
        case tappedBookmark(ExchangeRate)
    }

    enum Mutation {
        case setExchangeRates([ExchangeRate])
        case setError(Error)
        case setSearchBarText(String)
        case setFilteredExchangeRates([ExchangeRate])
        case updateBookmark([ExchangeRate])
    }

    struct State {
        var originalExchangeRates: [ExchangeRate] = []
        var searchBarText: String = ""
        var filteredExchangeRates: [ExchangeRate] = []
        var error: Error?
    }

    let state: BehaviorRelay<State>
    let action = PublishRelay<Action>()

    private let disposeBag: DisposeBag = .init()
    let useCase: ExchangeRateUseCaseProtocol

    init(exchangeUseCase: ExchangeRateUseCaseProtocol) {
        useCase = exchangeUseCase
        state = BehaviorRelay(value: State())
        setBindings()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .fetchExchangeRates:
            return useCase.fetchExchangeRates()
                .map { Mutation.setExchangeRates($0) }
                .catch { .just(Mutation.setError($0)) }
        case .updateSearchBarText(let text):
            return .just(Mutation.setSearchBarText(text))
        case .filterExchangeRates(let filteredExchangeRates):
            return .just(Mutation.setFilteredExchangeRates(filteredExchangeRates))
        case .tappedBookmark(let bookmarkedExchangeRate):
            let bookmarkedExchangeRates: [ExchangeRate] = useCase.bookmarkExchangeRate(
                bookmarkedExchangeRate: bookmarkedExchangeRate,
                originalExchangeRates: state.value.originalExchangeRates
            )
            return useCase.updateBookmarkedExchangeRate(
                bookmarkedExchangeRate: bookmarkedExchangeRate
            )
            .map { Mutation.updateBookmark(bookmarkedExchangeRates) }
            .catch { .just(.setError($0)) }
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setExchangeRates(let exchangeRates):
            newState.originalExchangeRates = exchangeRates
        case .setError(let error):
            newState.error = error
        case .setSearchBarText(let text):
            newState.searchBarText = text
        case .setFilteredExchangeRates(let filteredExchangeRates):
            newState.filteredExchangeRates = filteredExchangeRates
        case .updateBookmark(let bookmarkedExchangeRates):
            newState.originalExchangeRates = bookmarkedExchangeRates
        }

        return newState
    }
}

extension MainViewModel {
    func setBindings() {
        bindAction()
        bindState()
    }

    private func bindAction() {
        action
            .flatMap { [weak self] action -> Observable<Mutation> in
                guard let self else { return .empty() }
                return mutate(action: action)
            }
            .subscribe { [weak self] mutation in
                guard let self else { return }
                let newState = reduce(state: state.value, mutation: mutation)
                state.accept(newState)
            }
            .disposed(by: disposeBag)
    }

    private func bindState() {
        Observable.combineLatest(
            state.map(\.searchBarText).distinctUntilChanged(),
            state.map(\.originalExchangeRates).distinctUntilChanged()
        )
        .observe(on: MainScheduler.asyncInstance)
        .map { [weak self] searchbarText, exchangeRates -> [ExchangeRate] in
            self?.useCase.filterExchangeRates(
                text: searchbarText,
                originalExchangeRates: exchangeRates
            ) ?? []
        }
        .subscribe { [weak self] filteredExchangeRate in
            guard let self else { return }
            action.accept(.filterExchangeRates(filteredExchangeRate))
        }
        .disposed(by: disposeBag)
    }
}
