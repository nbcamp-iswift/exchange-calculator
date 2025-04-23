import XCTest
import CoreData
@testable import exchangeCalculator

struct ExchangeRatewFavMock {
    let currency: String
    let countryCode: String
    let rate: Double
    let isFavorite: Bool
    let createdAt: Date
    let lastUpdated: Int64
}

extension ExchangeRatewFavMock {
    static func mock(currency: String, rate: Double, isFavorite: Bool = false) -> Self {
        .init(
            currency: currency,
            countryCode: "MOCK",
            rate: rate,
            isFavorite: isFavorite,
            createdAt: Date(),
            lastUpdated: 123
        )
    }
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
    var allRates: [ExchangeRatewFavMock] = []

    func getAllExchangedRate() -> [ExchangeRatewFav] {
        allRates.map {
            let model = ExchangeRatewFav(context: mockContext)
            model.currency = $0.currency
            model.countryCode = $0.countryCode
            model.rate = $0.rate
            model.isFavorite = $0.isFavorite
            model.createdAt = $0.createdAt
            model.lastUpdated = $0.lastUpdated
            return model
        }
    }

    func getFavorites() -> [ExchangeRatewFav] {
        getAllExchangedRate().filter(\.isFavorite)
    }

    func saveOrUpdate(rate: ExchangeRate, isFavorite: Bool) {}
    func updateFavoriteStatus(currency: String, countryCode: String, isFavorite: Bool) {}
    func removeAll() {}
    func count() -> Int? { allRates.count }

    private lazy var mockContext: NSManagedObjectContext = {
        let container = NSPersistentContainer(name: "ExchangeRatewFav")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        container.persistentStoreDescriptions = [description]
        container.loadPersistentStores { _, error in
            if let error {
                fatalError("In-memory store load failed: \(error)")
            }
        }
        return container.viewContext
    }()
}

final class AppStateStoreMock: AppStateStore {
    func saveLastScreen(type: LastScreenType, selectedCurrency: String?) {}
    func loadLastScreen() -> LastScreenInfo {
        LastScreenInfo(screen: .table, selectedCurrency: nil)
    }
}

final class ExchangeRateViewModelTests: XCTestCase {
    var viewmodel: ExchangeRateViewModel!
    var apiRepo: ExchangeRateRepositoryMock!
    var coreDataRepo: ExchangeRateCoreDataRepostitoryMock!
    var appDataRepo: AppStateStoreMock!

    override func setUp() {
        super.setUp()
        apiRepo = ExchangeRateRepositoryMock()
        coreDataRepo = ExchangeRateCoreDataRepostitoryMock()
        appDataRepo = AppStateStoreMock()

        viewmodel = ExchangeRateViewModel(
            dataRepository: apiRepo,
            coreDataRepository: coreDataRepo,
            appDataRepository: appDataRepo
        )
    }

    override func tearDown() {
        viewmodel = nil
        apiRepo = nil
        coreDataRepo = nil
        appDataRepo = nil
        super.tearDown()
    }

    func test_directionUp_whenRateIncreased() {
        // Given
        let jpyRate = ExchangeRate(
            currency: "JPY",
            country: "Japan",
            rate: "150.00",
            timeLastUpdated: 12_345_678
        )
        apiRepo.result = .success([jpyRate])
        coreDataRepo.allRates = [
            .mock(currency: "JPY", rate: 82.0)
        ]

        // When
        viewmodel.loadRates()

        // Then
        let expectation = XCTestExpectation(description: "Loaded State with upward direction")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if case let .loaded(models) = self.viewmodel.state {
                XCTAssertEqual(models.first?.direction, .up)
                expectation.fulfill()
            } else {
                XCTFail("Expected loaded state")
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }

    func test_directionDown_whenRateDecreased() {
        // Given
        let usdRate = ExchangeRate(
            currency: "USD",
            country: "USA",
            rate: "1.0000",
            timeLastUpdated: 123
        )
        apiRepo.result = .success([usdRate])
        coreDataRepo.allRates = [
            .mock(currency: "USD", rate: 1.2)
        ]

        // When
        viewmodel.loadRates()

        // Then
        let expectation = XCTestExpectation(description: "Loaded State with downward direction")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if case let .loaded(models) = self.viewmodel.state {
                XCTAssertEqual(models.first?.direction, .down)
                expectation.fulfill()
            } else {
                XCTFail("Expected loaded state")
            }
        }

        wait(for: [expectation], timeout: 1.0)
    }
}
