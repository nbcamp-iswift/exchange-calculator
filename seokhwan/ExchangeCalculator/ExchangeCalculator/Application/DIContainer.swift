import UIKit

final class DIContainer {
    // MARK: - Data Layer

    func makeExchangeRateService() -> ExchangeRateService {
        ExchangeRateService()
    }

    func makeExchangeRateStorage() -> ExchangeRateStorage {
        ExchangeRateStorage()
    }

    func makeLastScreenStorage() -> LastScreenStorage {
        LastScreenStorage()
    }

    func makeExchangeRateRepository() -> ExchangeRateRepository {
        ExchangeRateRepository(
            exchangeRateService: makeExchangeRateService(),
            exchangeRateStorage: makeExchangeRateStorage()
        )
    }

    func makeLastSreenRepository() -> LastScreenRepository {
        LastScreenRepository(lastScreenStorage: makeLastScreenStorage())
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

    func makeLastScreenUseCase() -> LastScreenUseCase {
        LastScreenUseCase(lastScreenRepository: makeLastSreenRepository())
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

    func makeExchangeRateViewController(
        with coordinator: Coordinator
    ) -> ExchangeRateViewController {
        ExchangeRateViewController(
            coordinator: coordinator,
            viewModel: makeExchangeRateViewModel()
        )
    }

    func makeCalculatorViewController(
        coordinator: Coordinator,
        exchangeRate: ExchangeRate
    ) -> CalculatorViewController {
        CalculatorViewController(
            coordinator: coordinator,
            viewModel: makeCalculatorViewModel(with: exchangeRate)
        )
    }
}
