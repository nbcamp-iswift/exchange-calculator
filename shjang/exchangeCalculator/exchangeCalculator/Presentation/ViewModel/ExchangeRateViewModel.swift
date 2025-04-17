import Foundation
import Combine

final class ExchangeRateViewModel {
    enum State {
        case idle
        case loading
        case loaded
        case failed(String)
    }

    @Published private(set) var state: State = .idle
    private(set) var filteredRates: [ExchangeRate] = []

    private let repository: ExchangeRateRepository
    private var baseCurrency: String = "USD"
    private var rates: [ExchangeRate] = []

    init(repository: ExchangeRateRepository) {
        self.repository = repository
        loadRates()
    }

    func loadRates() {
        state = .loading
        repository.fetch(baseCurrency: baseCurrency) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.state = .loaded
                    self?.rates = data
                    self?.filteredRates = data
                case .failure(let error):
                    print("Failed to fetch exchange rates: \(error)")
                    self?.state = .failed(error.localizedDescription)
                }
            }
        }
    }

    func filter(with keyword: String) {
        guard !keyword.isEmpty else {
            filteredRates = rates
            return
        }

        filteredRates = rates.filter {
            $0.currency.lowercased().contains(keyword.lowercased()) ||
                $0.country.lowercased().contains(keyword.lowercased())
        }
    }

    func getExchangeRate(at index: Int) -> ExchangeRate {
        rates[index]
    }

    func getNumberOfRates() -> Int {
        rates.count
    }
}
