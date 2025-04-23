import UIKit

final class DIContainer {
    // MARK: - Data Layer

    func makeExchangeRateService() -> ExchangeRateService {
        ExchangeRateService()
    }

    func makeExchangeRateStorage() -> ExchangeRateStorage {
        ExchangeRateStorage.shared
    }

    func makeExchangeRateRepository() -> ExchangeRateRepository {
        ExchangeRateRepository(
            exchangeRateService: makeExchangeRateService(),
            exchangeRateStorage: makeExchangeRateStorage()
        )
    }

    // MARK: - Domain Layer

    func makeFetchExchangeRateUseCase() -> FetchExchangeRateUseCase {
        FetchExchangeRateUseCase(exchangeRateRepository: makeExchangeRateRepository())
    }

    func makeConvertExchangeRateUseCase() -> ConvertExchangeRateUseCase {
        ConvertExchangeRateUseCase()
    }

    func makeToggleIsFavoriteUseCase() -> ToggleIsFavoriteUseCase {
        ToggleIsFavoriteUseCase(exchangeRateRepository: makeExchangeRateRepository())
    }

    // MARK: - Presentation Layer

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
        ExchangeRateViewController(viewModel: makeExchangeRateViewModel(), diContainer: self)
    }

    func makeCalculatorViewController(with exchangeRate: ExchangeRate) -> CalculatorViewController {
        CalculatorViewController(viewModel: makeCalculatorViewModel(with: exchangeRate))
    }
}
