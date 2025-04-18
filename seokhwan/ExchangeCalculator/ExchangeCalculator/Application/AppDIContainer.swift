import UIKit

final class AppDIContainer {
    private let service: ExchangeRateService
    private let repository: ExchangeRateRepository

    init() {
        service = ExchangeRateService()
        repository = ExchangeRateRepository(exchangeRateService: service)
    }

    func makeExchangeRateViewController() -> ExchangeRateViewController {
        let useCase = ExchangeRateUseCase(exchangeRateRepository: repository)
        let viewModel = ExchangeRateViewModel(exchangeRateUseCase: useCase)

        return ExchangeRateViewController(viewModel: viewModel)
    }

    func makeCalculatorViewController() -> CalculatorViewController {
        let viewModel = CalculatorViewModel()

        return CalculatorViewController(viewModel: viewModel)
    }
}
