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

    func makeToggleIsFavoriteUseCase() -> ToggleIsFavoriteUseCase {
        ToggleIsFavoriteUseCase(exchangeRateRepository: makeExchangeRateRepository())
    }

    func makeExchangeRateViewModel() -> ExchangeRateViewModel {
        ExchangeRateViewModel(
            fetchExchangeRateUseCase: makeFetchExchangeRateUseCase(),
            toggleIsFavoriteUseCase: makeToggleIsFavoriteUseCase()
        )
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
