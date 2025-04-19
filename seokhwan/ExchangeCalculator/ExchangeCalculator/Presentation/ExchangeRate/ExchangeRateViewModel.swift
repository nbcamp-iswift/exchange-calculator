import Foundation
import Combine

final class ExchangeRateViewModel: ViewModelProtocol {
    enum Action {
        case viewDidLoad
        case searchTextDidChange(searchText: String)
        case cellDidTap(exchangeRate: ExchangeRate)
    }

    struct State {
        let exchangeRateInfo = CurrentValueSubject<ExchangeRateInfo, Never>(ExchangeRateInfo())
        let filteredExchangeRates = PassthroughSubject<ExchangeRates, Never>()
        let selectedExchangeRate = PassthroughSubject<ExchangeRate, Never>()
        let errorMessage = PassthroughSubject<String, Never>()
    }

    let action = PassthroughSubject<Action, Never>()
    let state = State()
    let useCase: FetchExchangeRateUseCase

    private var cancellables = Set<AnyCancellable>()

    init(exchangeRateUseCase: FetchExchangeRateUseCase) {
        useCase = exchangeRateUseCase

        action
            .sink { [weak self] action in
                guard let self else { return }

                switch action {
                case .viewDidLoad:
                    Task {
                        await self.fetchExchangeRates()
                    }
                case .searchTextDidChange(let searchText):
                    filterExchangeRates(by: searchText)
                case .cellDidTap(let exchangeRate):
                    state.selectedExchangeRate.send(exchangeRate)
                }
            }
            .store(in: &cancellables)
    }

    private func fetchExchangeRates() async {
        let result = await useCase.execute()

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
                let currency = $0.currency.lowercased()
                let country = $0.country.lowercased()

                return currency.contains(text) || country.contains(text)
            }

        state.filteredExchangeRates.send(result)
    }
}
