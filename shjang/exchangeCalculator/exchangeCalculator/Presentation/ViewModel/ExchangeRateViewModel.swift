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
    private let favoriteRepository: ExchangeRatewFavRepository

    private var baseCurrency: String = "USD"
    private var rates: [ExchangeRate] = []
    private var currentFilter: String = ""

    init(dataRepository: ExchangeRateRepository, favoriteRepository: ExchangeRatewFavRepository) {
        self.dataRepository = dataRepository
        self.favoriteRepository = favoriteRepository
        loadRates()
    }

    func loadRates() {
        state = .loading
        dataRepository.fetch(baseCurrency: baseCurrency) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let data):
                    self?.rates = data
                    self?.updateViewModel()
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
        let favorites = Set(favoriteRepository.getFavorites().map(\.currency))

        let filtered = rates.filter {
            currentFilter.isEmpty ||
                normalize($0.currency).contains(normalizedKeyword) ||
                normalize($0.country).contains(normalizedKeyword)
        }

        let mapped = filtered.map {
            ExchangeRateTableViewCellModel(
                from: $0,
                isFavorite: favorites.contains($0.currency)
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
        favoriteRepository.updateFavoriteStatus(
            currency: currency,
            countryCode: country,
            isFavorite: isFavorite
        )

        updateViewModel()
    }

    private func normalize(_ text: String) -> String {
        text.folding(options: .diacriticInsensitive, locale: .current)
            .replacingOccurrences(of: " ", with: "")
            .lowercased()
    }
}
