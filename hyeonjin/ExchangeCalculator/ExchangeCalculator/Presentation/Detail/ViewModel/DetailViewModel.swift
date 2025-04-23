//
//  DetailViewModel.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/20/25.
//

import Foundation
import RxSwift
import RxCocoa

enum ConvertError: String, Error, Hashable {
    case empty = "금액을 입력해 주세요"
    case invalidValue = "올바른 숫자를 입력해 주세요"
}

final class DetailViewModel: ViewModelProtocol {
    enum Action {
        case tappedConvertButton
        case updateAmount(String)
        case resetErrorState
    }

    enum Mutation {
        case setResult(String)
        case setAmount(String)
        case setError(ConvertError)
        case clearError
    }

    struct State {
        let exchangeRate: ExchangeRate
        var amount: String = ""
        var convertedResult: String = ""
        var error: ConvertError?
    }

    let state: BehaviorRelay<State>
    let action = PublishRelay<Action>()

    private let disposeBag: DisposeBag = .init()

    init(exchangeRate: ExchangeRate) {
        state = BehaviorRelay(value: .init(exchangeRate: exchangeRate))
        setBindings()
    }

    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .tappedConvertButton:
            guard !state.value.amount.isEmpty else {
                return .just(.setError(.empty))
            }

            guard let amount = Double(state.value.amount) else {
                return .just(.setError(.invalidValue))
            }

            let result = amount * (Double(state.value.exchangeRate.value) ?? 0.0)
            return .just(Mutation.setResult(
                String(format: "$%.2f → %.2f %@", amount, result, state.value.exchangeRate.country)
            ))
        case .updateAmount(let amount):
            return .just(Mutation.setAmount(amount))
        case .resetErrorState:
            return .just(Mutation.clearError)
        }
    }

    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state

        switch mutation {
        case .setResult(let result):
            newState.convertedResult = result
        case .setAmount(let amount):
            newState.amount = amount
        case .setError(let error):
            newState.error = error
        case .clearError:
            newState.error = nil
        }

        return newState
    }
}

extension DetailViewModel {
    func setBindings() {
        bindAction()
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
}
