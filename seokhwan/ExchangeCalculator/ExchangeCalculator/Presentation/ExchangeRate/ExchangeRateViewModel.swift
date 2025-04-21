import Foundation
import RxSwift
import RxRelay

final class ExchangeRateViewModel: ViewModelProtocol {
    enum Action {
        case viewDidLoad
        case didChangeSearchText(searchText: String)
        case didTapCell(exchangeRate: ExchangeRate)
    }

    struct State {
        let exchangeRateInfo = BehaviorRelay<ExchangeRateInfo>(value: ExchangeRateInfo())
        let filteredExchangeRates = PublishRelay<ExchangeRates>()
        let selectedExchangeRate = PublishRelay<ExchangeRate>()
        let errorMessage = PublishRelay<String>()
    }

    let action = PublishRelay<Action>()
    let state = State()
    let useCase: FetchExchangeRateUseCase

    private let disposeBag = DisposeBag()

    init(exchangeRateUseCase: FetchExchangeRateUseCase) {
        useCase = exchangeRateUseCase

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
                    self?.state.selectedExchangeRate.accept(exchangeRate)
                }
            }
            .disposed(by: disposeBag)
    }

    private func fetchExchangeRates() async {
        let result = await useCase.execute()

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
}
