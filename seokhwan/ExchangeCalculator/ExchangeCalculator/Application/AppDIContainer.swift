import UIKit

final class AppDIContainer {
    func makeExchangeRateService() -> ExchangeRateService {
        ExchangeRateService()
    }

    func makeExchangeRateRepository() -> ExchangeRateRepository {
        ExchangeRateRepository(exchangeRateService: makeExchangeRateService())
    }

    func makeFetchExchangeRateUseCase() -> FetchExchangeRateUseCase {
        FetchExchangeRateUseCase(exchangeRateRepository: makeExchangeRateRepository())
    }

    func makeConvertExchangeRateUseCase() -> ConvertExchangeRateUseCase {
        ConvertExchangeRateUseCase()
    }

    func makeExchangeRateViewModel() -> ExchangeRateViewModel {
        ExchangeRateViewModel(exchangeRateUseCase: makeFetchExchangeRateUseCase())
    }

    func makeCalculatorViewModel(with exchangeRate: ExchangeRate) -> CalculatorViewModel {
        CalculatorViewModel(
            exchangeRate: exchangeRate,
            convertExchangeRateUseCase: makeConvertExchangeRateUseCase()
        )
    }

    func makeExchangeRateViewController() -> ExchangeRateViewController {
        ExchangeRateViewController(viewModel: makeExchangeRateViewModel(), container: self)
    }

    func makeCalculatorViewController(with exchangeRate: ExchangeRate) -> CalculatorViewController {
        CalculatorViewController(viewModel: makeCalculatorViewModel(with: exchangeRate))
    }
}
