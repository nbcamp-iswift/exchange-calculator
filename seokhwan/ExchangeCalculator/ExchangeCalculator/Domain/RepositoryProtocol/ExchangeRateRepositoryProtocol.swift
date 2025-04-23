import Foundation

protocol ExchangeRateRepositoryProtocol {
    func fetchExchangeRates() async -> Result<ExchangeRateInfo, ExchangeRateError>
    func toggleIsFavorite(for currency: String) async -> Result<Void, ExchangeRateError>
}
