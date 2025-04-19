import Foundation
import Combine

final class CalculatorViewModel: ViewModelProtocol {
    enum Action {
        case viewDidLoad
    }

    struct State {
        let exchangeRate = PassthroughSubject<ExchangeRate, Never>()
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
                }
            }
            .store(in: &cancellables)
    }
}
