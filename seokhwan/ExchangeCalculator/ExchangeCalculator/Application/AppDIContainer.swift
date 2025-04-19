import UIKit

final class AppDIContainer {
    private let service: ExchangeRateService
    private let repository: ExchangeRateRepository

    init() {
        service = ExchangeRateService()
        repository = ExchangeRateRepository(exchangeRateService: service)
    }

    func makeExchangeRateViewController() -> ExchangeRateViewController {
        let useCase = FetchExchangeRateUseCase(exchangeRateRepository: repository)
        let viewModel = ExchangeRateViewModel(exchangeRateUseCase: useCase)

        return ExchangeRateViewController(viewModel: viewModel, container: self)
    }

    func makeCalculatorViewController(with exchangeRate: ExchangeRate) -> CalculatorViewController {
        let useCase = ConvertExchangeRateUseCase()
        let viewModel = CalculatorViewModel(
            exchangeRate: exchangeRate,
            convertExchangeRateUseCase: useCase
        )

        return CalculatorViewController(viewModel: viewModel)
    }
}
