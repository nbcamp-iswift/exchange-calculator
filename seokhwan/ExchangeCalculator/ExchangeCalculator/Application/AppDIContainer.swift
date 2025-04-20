import UIKit

final class AppDIContainer {
    func makeExchangeRateViewController() -> ExchangeRateViewController {
        let service = ExchangeRateService()
        let repository = ExchangeRateRepository(exchangeRateService: service)
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
