import Foundation
import RxSwift
import RxRelay

final class ExchangeRateViewModel: ViewModelProtocol {
    enum Action {
        case viewDidLoad
        case didChangeSearchText(searchText: String)
        case didTapCell(exchangeRate: ExchangeRate)
        case didTapFavoriteButton(currency: String)
    }

    struct State {
        let exchangeRateInfo = BehaviorRelay<ExchangeRateInfo>(value: ExchangeRateInfo())
        let filteredExchangeRates = PublishRelay<ExchangeRates>()
        let selectedExchangeRate = PublishRelay<ExchangeRate>()
        let errorMessage = PublishRelay<String>()
    }

    let action = PublishRelay<Action>()
    let state = State()
    let fetchExchangeRateUseCase: FetchExchangeRateUseCase
    let toggleIsFavoriteUseCase: ToggleIsFavoriteUseCase

    private let disposeBag = DisposeBag()

    init(
        fetchExchangeRateUseCase: FetchExchangeRateUseCase,
        toggleIsFavoriteUseCase: ToggleIsFavoriteUseCase
    ) {
        self.fetchExchangeRateUseCase = fetchExchangeRateUseCase
        self.toggleIsFavoriteUseCase = toggleIsFavoriteUseCase

        action
            .subscribe { [weak self] action in
                switch action {
                case .viewDidLoad:
                    Task {
                        await self?.fetchExchangeRates()
                    }
                case .didChangeSearchText(let text):
                    self?.filterExchangeRates(by: text)
                case .didTapCell(let exchangeRate):
                    self?.selectExchangeRate(exchangeRate)
                case .didTapFavoriteButton(let currency):
                    Task {
                        await self?.toggleIsFavorite(for: currency)
                    }
                }
            }
            .disposed(by: disposeBag)
    }

    private func fetchExchangeRates() async {
        let result = await fetchExchangeRateUseCase.execute()

        switch result {
        case .success(let info):
            state.exchangeRateInfo.accept(info)
            state.filteredExchangeRates.accept(info.exchangeRates)
        case .failure(let error):
            state.errorMessage.accept(error.localizedDescription)
        }
    }

    private func filterExchangeRates(by searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !text.isEmpty else {
            let exchangeRates = state.exchangeRateInfo.value.exchangeRates
            state.filteredExchangeRates.accept(exchangeRates)

            return
        }
        let result = state.exchangeRateInfo.value.exchangeRates
            .filter {
                let currency = $0.currency.lowercased()
                let country = $0.country.lowercased()

                return currency.contains(text) || country.contains(text)
            }

        state.filteredExchangeRates.accept(result)
    }

    private func selectExchangeRate(_ exchangeRate: ExchangeRate) {
        state.selectedExchangeRate.accept(exchangeRate)
    }

    private func toggleIsFavorite(for currency: String) async {
        let result = await toggleIsFavoriteUseCase.execute(for: currency)

        switch result {
        case .success:
            await fetchExchangeRates()
        case .failure(let error):
            state.errorMessage.accept(error.localizedDescription)
        }
    }
}
