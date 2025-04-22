import XCTest
import CoreData
@testable import exchangeCalculator

struct ExchangeRatewFavMock {
    let currency: String
    let countryCode: String = ""
    let rate: Double
    let isFavorite: Bool
    let createdAt = Date()
    let lastUpdated: Int64 = 0
}

final class ExchangeRateRepositoryMock: ExchangeRateRepository {
    var result: Result<[ExchangeRate], Error> = .success([])
    func fetch(
        baseCurrency: String,
        completion: @escaping (Result<[ExchangeRate], any Error>) -> Void
    ) {
        completion(result)
    }
}

final class ExchangeRateCoreDataRepostitoryMock: CoreDataStackProtocol {
    var allRates: [exchangeCalculator.ExchangeRatewFav] = []

    func getAllExchangedRate() -> [exchangeCalculator.ExchangeRatewFav] {
        allRates
    }

    func getFavorites() -> [exchangeCalculator.ExchangeRatewFav] {
        allRates.filter(\.isFavorite)
    }

    func updateFavoriteStatus(
        currency: String,
        countryCode: String,
        isFavorite: Bool
    ) {}

    func removeAll() {}
    func count() -> Int? { nil }
}

final class ExchangeRateViewModelTests: XCTestCase {
    var viewmodel: ExchangeRateViewModel!
    var apiRepo: ExchangeRateRepositoryMock!
    var coreDataRepo: ExchangeRateCoreDataRepostitoryMock!

    override func setUp() {
        super.setUp()
        apiRepo = ExchangeRateRepositoryMock()
        coreDataRepo = ExchangeRateCoreDataRepostitoryMock()
        viewmodel = ExchangeRateViewModel(
            dataRepository: apiRepo,
            coreDataRepository: coreDataRepo
        )
    }

    override func tearDown() {
        viewmodel = nil
        apiRepo = nil
        coreDataRepo = nil
        super.tearDown()
    }

    private func mockRate(currency: String, rate: Double) -> ExchangeRatewFav {
        let mock = ExchangeRatewFav(
            context: NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        )
        mock.currency = currency
        mock.countryCode = "Mock"
        mock.rate = rate
        mock.isFavorite = false
        mock.lastUpdated = 123
        mock.createdAt = Date()
        return mock
    }

    func test_directionUp_whenRateIncreased() {
        // 1. Given
        let jpyRate = ExchangeRate(
            currency: "JPY",
            country: "Japan",
            rate: "150.00",
            timeLastUpdated: 12_345_678
        )
        apiRepo.result = .success([jpyRate])
        coreDataRepo.allRates = [mockRate(currency: "JPY", rate: 82.0)]
        // 2. When
        viewmodel.loadRates()

        // 3 Then
        let exepction: XCTestExpectation = expectation(
            description: "Loaded State with upward direction")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if case let .loaded(models) = self.viewmodel.state {
                XCTAssertEqual(models.first?.direction, .up)
                exepction.fulfill()
            } else {
                XCTFail("Expected loaded state")
            }
        }

        waitForExpectations(timeout: 1.0)
    }

    func test_directionDown_whenRateDecreased() {
        // 1. Given
        let usdRate = ExchangeRate(
            currency: "USD",
            country: "USA",
            rate: "1.0000",
            timeLastUpdated: 123
        )
        apiRepo.result = .success([usdRate])
        coreDataRepo.allRates = [mockRate(currency: "USD", rate: 1.2)]

        // 2. When
        viewmodel.loadRates()

        // 3. Then
        let exepction: XCTestExpectation = expectation(
            description: "Loaded State with downward direction")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if case let .loaded(models) = self.viewmodel.state {
                XCTAssertEqual(models.first?.direction, .down)
                exepction.fulfill()
            } else {
                XCTFail("Expected loaded state")
            }
        }
        waitForExpectations(timeout: 1.0)
    }
}
