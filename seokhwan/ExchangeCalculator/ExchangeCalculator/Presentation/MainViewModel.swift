import Foundation
import Combine
import Alamofire

final class MainViewModel {
    private let service = ExchangeRateService()
    private var allExchangeRatesSubject = CurrentValueSubject<ExchangeRates, Never>(ExchangeRates())
    private let filteredExchangeRatesSubject = PassthroughSubject<[ExchangeRate], Never>()
    private let errorSubject = PassthroughSubject<AFError, Never>()
    private var cancellables = Set<AnyCancellable>()

    var exchangeRatesPublisher: AnyPublisher<[ExchangeRate], Never> {
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
            let result = await service.fetchExchangeRates(for: currency)

            switch result {
            case .success(let value):
                let exchangeRates = ExchangeRates(from: value)
                allExchangeRatesSubject.send(exchangeRates)
                filteredExchangeRatesSubject.send(exchangeRates.rates)
            case .failure(let error):
                errorSubject.send(error)
            }
        }
    }

    private func filterExchangeRates(by searchText: String) {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        guard !text.isEmpty else {
            filteredExchangeRatesSubject.send(allExchangeRatesSubject.value.rates)
            return
        }

        let result = allExchangeRatesSubject.value.rates
            .filter {
                let currencyCode = $0.currencyCode.lowercased()
                let countryName = CountryNameMapper.countryName(from: $0.currencyCode).lowercased()

                return currencyCode.contains(text) || countryName.contains(text)
            }

        filteredExchangeRatesSubject.send(result)
    }
}
