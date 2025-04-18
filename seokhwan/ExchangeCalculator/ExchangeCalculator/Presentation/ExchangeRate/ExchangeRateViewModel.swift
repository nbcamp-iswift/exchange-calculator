import Foundation
import Combine

final class ExchangeRateViewModel {
    let useCase: ExchangeRateUseCase

    // TODO: Info를 repository와 VM 두 곳에서 가지고 있는 것 괜찮은지 고민해 보기
    private let exchangeRateInfoSubject = CurrentValueSubject<ExchangeRateInfo, Never>(
        ExchangeRateInfo()
    )
    private let filteredExchangeRatesSubject = PassthroughSubject<ExchangeRates, Never>()
    private let errorMessageSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    var exchangeRatesPublisher: AnyPublisher<ExchangeRates, Never> {
        filteredExchangeRatesSubject.eraseToAnyPublisher()
    }

    var errorMessagePublisher: AnyPublisher<String, Never> {
        errorMessageSubject.eraseToAnyPublisher()
    }

    init(exchangeRateUseCase: ExchangeRateUseCase) {
        useCase = exchangeRateUseCase
    }

//    init(
//        _ viewDidLoadPublisher: AnyPublisher<Void, Never>,
//        _ searchTextDidChangePublisher: AnyPublisher<String, Never>
//    ) {
//        viewDidLoadPublisher
//            .sink { [weak self] _ in
//                self?.fetchExchangeRates(for: "USD")
//            }
//            .store(in: &cancellables)
//
//        searchTextDidChangePublisher
//            .sink { [weak self] searchText in
//                self?.filterExchangeRates(by: searchText)
//            }
//            .store(in: &cancellables)
//    }

    private func fetchExchangeRates(for currency: String) async {
        let result = await useCase.fetchExchangeRates(for: currency)

        switch result {
        case .success(let info):
            exchangeRateInfoSubject.send(info)
            filteredExchangeRatesSubject.send(info.exchangeRates)
        case .failure(let error):
            errorMessageSubject.send(error.localizedDescription)
        }
    }

    private func filterExchangeRates(by searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !text.isEmpty else {
            filteredExchangeRatesSubject.send(exchangeRateInfoSubject.value.exchangeRates)
            return
        }
        let result = exchangeRateInfoSubject.value.exchangeRates
            .filter {
                let currencyCode = $0.currency.lowercased()
                let countryName = CurrencyCountryMapper.country(for: $0.currency).lowercased()

                return currencyCode.contains(text) || countryName.contains(text)
            }

        filteredExchangeRatesSubject.send(result)
    }
}
