import Foundation
import Combine
import Alamofire

final class MainViewModel {
    private let service = ExchangeRateService()
    private let exchangeRatesSubject = PassthroughSubject<ExchangeRates, Never>()
    private let errorSubject = PassthroughSubject<AFError, Never>()
    private var cancellables = Set<AnyCancellable>()

    var exchangeRatesPublisher: AnyPublisher<ExchangeRates, Never> {
        return exchangeRatesSubject.eraseToAnyPublisher()
    }

    var errorPublisher: AnyPublisher<AFError, Never> {
        return errorSubject.eraseToAnyPublisher()
    }

    init(_ viewDidLoadPublisher: AnyPublisher<Void, Never>) {
        viewDidLoadPublisher
            .sink { [weak self] _ in
                self?.fetchExchangeRates(for: "USD")
            }
            .store(in: &cancellables)
    }

    private func fetchExchangeRates(for currency: String) {
        Task {
            let result = await service.fetchExchangeRates(for: currency)

            switch result {
            case .success(let value):
                exchangeRatesSubject.send(ExchangeRates(from: value))
            case .failure(let error):
                errorSubject.send(error)
            }
        }
    }
}
