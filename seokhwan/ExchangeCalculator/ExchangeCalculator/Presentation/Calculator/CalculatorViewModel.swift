import Foundation
import RxSwift
import RxRelay

final class CalculatorViewModel: ViewModelProtocol {
    // MARK: - Types

    enum Action {
        case viewDidLoad
        case convert(input: String)
    }

    struct State {
        let exchangeRate = PublishRelay<ExchangeRate>()
        let convertedAmount = PublishRelay<Double>()
        let errorMessage = PublishRelay<String>()
    }

    // MARK: - Properties

    let action = PublishRelay<Action>()
    let state = State()
    let useCase: ConvertExchangeRateUseCase

    private let disposeBag = DisposeBag()

    // MARK: - Initializers

    init(
        exchangeRate: ExchangeRate,
        convertExchangeRateUseCase: ConvertExchangeRateUseCase
    ) {
        useCase = convertExchangeRateUseCase

        action
            .bind { [weak self] action in
                guard let self else { return }

                switch action {
                case .viewDidLoad:
                    state.exchangeRate.accept(exchangeRate)
                case .convert(let input):
                    let result = useCase.execute(input: input, rate: exchangeRate.value)

                    switch result {
                    case .success(let amount):
                        state.convertedAmount.accept(amount)
                    case .failure(let error):
                        state.errorMessage.accept(error.localizedDescription)
                    }
                }
            }
            .disposed(by: disposeBag)
    }
}
