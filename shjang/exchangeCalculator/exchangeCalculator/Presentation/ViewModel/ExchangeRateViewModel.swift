import Foundation
import Combine

final class ExchangeRateViewModel {
    enum State {
        case idle
        case loading
        case loaded([ExchangeRateCellViewModel])
        case failed(String)
    }

    @Published private(set) var state: State = .idle

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
                    let cellViewmodel = data.map { ExchangeRateCellViewModel(from: $0) }
                    self?.state = .loaded(cellViewmodel)
                    self?.rates = data
                case .failure(let error):
                    print("Failed to fetch exchange rates: \(error)")
                    self?.state = .failed(error.localizedDescription)
                }
            }
        }
    }

    func filter(with keyword: String) {
        guard !keyword.isEmpty else {
            state = .loaded(rates.map { ExchangeRateCellViewModel(from: $0) })
            return
        }

        let filtered = rates.filter {
            $0.currency.lowercased().contains(keyword.lowercased()) ||
                $0.country.lowercased().contains(keyword.lowercased())
        }
        state = .loaded(filtered.map { ExchangeRateCellViewModel(from: $0) })
    }

    func getExchangeRate(at index: Int) -> ExchangeRate {
        rates[index]
    }

    func getNumberOfRates() -> Int {
        rates.count
    }
}
