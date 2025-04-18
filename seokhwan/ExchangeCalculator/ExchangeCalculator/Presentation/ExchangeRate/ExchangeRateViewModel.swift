import Foundation
import Combine

final class ExchangeRateViewModel: ViewModelProtocol {
    enum Action {
        case viewDidLoad
        case searchTextDidChange(searchText: String)
        case cellDidTap
    }

    struct State {
        let exchangeRateInfo = CurrentValueSubject<ExchangeRateInfo, Never>(ExchangeRateInfo())
        let filteredExchangeRates = PassthroughSubject<ExchangeRates, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
    }

    let action = PassthroughSubject<Action, Never>()
    let state = State()
    let useCase: ExchangeRateUseCase

    private var cancellables = Set<AnyCancellable>()

    init(exchangeRateUseCase: ExchangeRateUseCase) {
        useCase = exchangeRateUseCase

        action
            .sink { [weak self] action in
                switch action {
                case .viewDidLoad:
                    Task {
                        await self?.fetchExchangeRates()
                    }
                case .searchTextDidChange(let searchText):
                    self?.filterExchangeRates(by: searchText)
                case .cellDidTap:
                    () // TODO: Cell 탭 이벤트 구현
                }
            }
            .store(in: &cancellables)
    }

    private func fetchExchangeRates(for currency: String? = nil) async {
        let result = await useCase.fetchExchangeRates(for: currency)

        switch result {
        case .success(let info):
            state.exchangeRateInfo.send(info)
            state.filteredExchangeRates.send(info.exchangeRates)
        case .failure(let error):
            state.errorMessage.send(error.localizedDescription)
        }
    }

    private func filterExchangeRates(by searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !text.isEmpty else {
            state.filteredExchangeRates.send(state.exchangeRateInfo.value.exchangeRates)
            return
        }
        let result = state.exchangeRateInfo.value.exchangeRates
            .filter {
                let currencyCode = $0.currency.lowercased()
                let countryName = CurrencyCountryMapper.country(for: $0.currency).lowercased()

                return currencyCode.contains(text) || countryName.contains(text)
            }

        state.filteredExchangeRates.send(result)
    }
}
