import Foundation

final class LastScreenRepository {
    private let service: LastScreenStorage

    init(lastScreenStorage: LastScreenStorage) {
        service = lastScreenStorage
    }

    func fetchLastScreen() async -> String {
        await service.fetch() ?? "ExchangeRateView"
    }

    func updateLastScreen(to lastScreen: String) async {
        await service.update(to: lastScreen)
    }
}
