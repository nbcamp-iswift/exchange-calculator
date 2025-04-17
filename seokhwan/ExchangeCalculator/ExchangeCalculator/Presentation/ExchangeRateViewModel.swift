import Foundation
import Combine
import Alamofire

final class ExchangeRateViewModel {
    private let service = ExchangeRateService()
    private var exchangeRateInfoSubject = CurrentValueSubject<ExchangeRateInfo, Never>(
        ExchangeRateInfo()
    )
    private let filteredExchangeRatesSubject = PassthroughSubject<ExchangeRates, Never>()
    private let errorSubject = PassthroughSubject<AFError, Never>()
    private var cancellables = Set<AnyCancellable>()

    var exchangeRatesPublisher: AnyPublisher<ExchangeRates, Never> {
        filteredExchangeRatesSubject.eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<AFError, Never> {
        errorSubject.eraseToAnyPublisher()
    }

    init(
        _ viewDidLoadPublisher: AnyPublisher<Void, Never>,
        _ searchTextDidChangePublisher: AnyPublisher<String, Never>
    ) {
        viewDidLoadPublisher
            .sink { [weak self] _ in
                self?.fetchExchangeRates(for: "USD")
            }
            .store(in: &cancellables)

        searchTextDidChangePublisher
            .sink { [weak self] searchText in
                self?.filterExchangeRates(by: searchText)
            }
            .store(in: &cancellables)
    }

    private func fetchExchangeRates(for currency: String) {
        Task {
            let result = await service.fetchExchangeRateInfo(for: currency)

            switch result {
            case .success(let value):
                let exchangeRatesInfo = ExchangeRateInfo(from: value)
                exchangeRateInfoSubject.send(exchangeRatesInfo)
                filteredExchangeRatesSubject.send(exchangeRatesInfo.exchangeRates)
            case .failure(let error):
                errorSubject.send(error)
            }
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
