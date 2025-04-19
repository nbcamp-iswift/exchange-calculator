import Foundation
import Combine

final class CalculatorViewModel: ViewModelProtocol {
    enum Action {
        case viewDidLoad
        case convert(amount: String)
    }

    struct State {
        let exchangeRate = PassthroughSubject<ExchangeRate, Never>()
        let result = PassthroughSubject<String, Never>()
    }

    let action = PassthroughSubject<Action, Never>()
    let state = State()

    private var cancellables = Set<AnyCancellable>()

    init(exchangeRate: ExchangeRate) {
        action
            .sink { [weak self] action in
                switch action {
                case .viewDidLoad:
                    self?.state.exchangeRate.send(exchangeRate)
                    self?.state.result.send("계산 결과가 여기에 표시됩니다")
                case .convert(let amount):
                    print(amount) // TODO: amount -> result UseCase 메서드 호출
                }
            }
            .store(in: &cancellables)
    }
}
