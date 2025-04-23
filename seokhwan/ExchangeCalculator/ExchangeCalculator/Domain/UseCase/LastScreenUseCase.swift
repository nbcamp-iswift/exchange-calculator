import Foundation

// TODO: 이 요소가 UseCase로 분리될만한 요소인지 고민해 보기
final class LastScreenUseCase {
    private let repository: LastScreenRepository

    init(lastScreenRepository: LastScreenRepository) {
        repository = lastScreenRepository
    }

    func fetch() async -> LastScreen {
        await repository.fetchLastScreen()
    }

    func updateLastScreen(to type: LastScreenType, with exchangeRate: ExchangeRate? = nil) async {
        await repository.updateLastScreen(to: type, with: exchangeRate)
    }
}
