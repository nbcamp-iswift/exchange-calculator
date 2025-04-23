import Foundation

protocol LastScreenRepositoryProtocol {
    func fetchLastScreen() async -> LastScreen
    func updateLastScreen(to type: LastScreenType, with exchangeRate: ExchangeRate?) async
}
