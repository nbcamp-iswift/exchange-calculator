import Foundation
import Combine

final class ExchangeRateViewModel {
    enum State {
        case idle
        case loading
        case loaded([ExchangeRateTableViewCellModel])
        case failed(String)
    }

    @Published private(set) var state: State = .idle

    private let dataRepository: ExchangeRateRepository
    private let coreDataRepository: CoreDataStackProtocol
    let appDataRepository: AppStateStore

    private var baseCurrency: String = "USD"
    private var rates: [ExchangeRate] = [] // current
    private var currentFilter: String = ""
    private var previousRate: [String: Double] = [:]

    init(
        dataRepository: ExchangeRateRepository,
        coreDataRepository: CoreDataStackProtocol,
        appDataRepository: AppStateStore
    ) {
        self.dataRepository = dataRepository
        self.coreDataRepository = coreDataRepository
        self.appDataRepository = appDataRepository
        loadRates()
    }

    func viewWillAppear() {
        appDataRepository.saveLastScreen(type: .table, selectedCurrency: nil)
    }

    func viewWillDisappear() {
        appDataRepository.saveLastScreen(type: .table, selectedCurrency: nil)
    }

    func loadRates() {
        state = .loading
        dataRepository.fetch(baseCurrency: baseCurrency) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.rates = data
                    self?.loadCacheData()
                    self?.updateViewModel()
                    self?.saveCurrentRatesForNext()
                case .failure(let error):
                    self?.state = .failed(error.localizedDescription)
                }
            }
        }
    }

    func filter(with keyword: String) {
        currentFilter = keyword
        updateViewModel()
    }

    private func updateViewModel() {
        let normalizedKeyword = normalize(currentFilter)
        let favorites = Set(coreDataRepository.getFavorites().map(\.currency))
        let filtered = rates.filter {
            currentFilter.isEmpty ||
                normalize($0.currency).contains(normalizedKeyword) ||
                normalize($0.country).contains(normalizedKeyword)
        }

        let mapped = filtered.map { rate -> ExchangeRateTableViewCellModel in
            let current = Double(rate.rate) ?? 0.0
            let previous = previousRate[rate.currency]

            let direction: Direction? = {
                guard let previous else { return nil }
                let diff = abs(current - previous)
                return diff > 0.01 ? (current > previous ? .up : .down) : nil
            }()

            return ExchangeRateTableViewCellModel(
                from: rate,
                isFavorite: favorites.contains(rate.currency),
                direction: direction
            )
        }

        let sorted = mapped.sorted {
            if $0.isFavorite == $1.isFavorite {
                return $0.title < $1.title
            }
            return $0.isFavorite && !$1.isFavorite
        }
        state = .loaded(sorted)
    }

    func getExchangeRate(at index: Int) -> ExchangeRate {
        rates[index]
    }

    func getNumberOfRates() -> Int {
        rates.count
    }

    func toggleFavorite(currency: String, country: String, isFavorite: Bool) {
        coreDataRepository.updateFavoriteStatus(
            currency: currency,
            countryCode: country,
            isFavorite: isFavorite
        )

        updateViewModel()
    }

    private func loadCacheData() {
        // NOTE: danger operation
        let cachedData = coreDataRepository.getAllExchangedRate()
        previousRate = Dictionary(uniqueKeysWithValues:
            cachedData.map { ($0.currency, $0.rate) })
    }

    private func saveCurrentRatesForNext() {
        let favorites = Set(coreDataRepository.getFavorites().map(\.currency))

        for rate in rates {
            let isFavorite = favorites.contains(rate.currency)
            coreDataRepository.saveOrUpdate(
                rate: rate,
                isFavorite: isFavorite
            )
        }
    }

    private func normalize(_ text: String) -> String {
        text.folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(of: " ", with: "")
            .lowercased()
    }
}
