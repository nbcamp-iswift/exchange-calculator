import Foundation
import Combine

final class CalculatorViewModel: ViewModelProtocol {
    enum Action {
        case viewDidLoad
        case convert(input: String)
    }

    struct State {
        let exchangeRate = PassthroughSubject<ExchangeRate, Never>()
        let convertedAmount = PassthroughSubject<Double, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
    }

    let action = PassthroughSubject<Action, Never>()
    let state = State()
    let useCase: ConvertExchangeRateUseCase

    private var cancellables = Set<AnyCancellable>()

    init(
        exchangeRate: ExchangeRate,
        convertExchangeRateUseCase: ConvertExchangeRateUseCase
    ) {
        useCase = convertExchangeRateUseCase

        action
            .sink { [weak self] action in
                guard let self else { return }

                switch action {
                case .viewDidLoad:
                    state.exchangeRate.send(exchangeRate)
                case .convert(let input):
                    let result = useCase.execute(input: input, rate: exchangeRate.value)

                    switch result {
                    case .success(let amount):
                        state.convertedAmount.send(amount)
                    case .failure(let error):
                        state.errorMessage.send(error.localizedDescription)
                    }
                }
            }
            .store(in: &cancellables)
    }
}
