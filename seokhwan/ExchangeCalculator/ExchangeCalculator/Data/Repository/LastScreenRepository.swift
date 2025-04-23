import Foundation

final class LastScreenRepository: LastScreenRepositoryProtocol {
    private let service: LastScreenStorage

    init(lastScreenStorage: LastScreenStorage) {
        service = lastScreenStorage
    }

    func fetchLastScreen() async -> LastScreen {
        if let entity = await service.fetch(),
           let type = LastScreenType(rawValue: entity.name) {
            var tempExchangeRate: ExchangeRate?

            if type == .calculatorView,
               let exchangeRate = entity.exchangeRate {
                tempExchangeRate = ExchangeRate(
                    currency: exchangeRate.currency,
                    country: CurrencyCountryMapper.country(for: exchangeRate.currency),
                    value: exchangeRate.oldValue,
                    oldValue: 0.0, // 의미없는 임시 값
                    isFavorite: false // 의미없는 임시 값
                )
            }

            return LastScreen(type: type, exchangeRate: tempExchangeRate)
        }
        return LastScreen(type: .exchangeRateView, exchangeRate: nil)
    }

    func updateLastScreen(to type: LastScreenType, with exchangeRate: ExchangeRate?) async {
        await service.updateLastScreen(to: type.rawValue, with: exchangeRate)
    }
}
