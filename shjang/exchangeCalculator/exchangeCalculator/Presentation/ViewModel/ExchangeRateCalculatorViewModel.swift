import Foundation

final class ExchangeRateCalculatorViewModel {
    let currency: String
    let countryName: String
    let exchangeRate: String
    private let appDataRepository: AppStateStore

    @Published private(set) var result: String = ""

    init(
        currency: String,
        countryName: String,
        exchangeRate: String,
        appDataRepository: AppStateStore
    ) {
        self.currency = currency
        self.countryName = countryName
        self.exchangeRate = exchangeRate
        self.appDataRepository = appDataRepository
    }

    func convert(amount: Double) {
        guard let rate = Double(exchangeRate) else {
            result = ""
            return
        }
        result = String(format: "%.2f", amount * rate)
    }

    func viewWillAppear() {
        appDataRepository.saveLastScreen(
            type: .calculator,
            selectedCurrency: currency
        )
    }

    func viewWillDisappear() {
        appDataRepository.saveLastScreen(
            type: .calculator,
            selectedCurrency: currency
        )
    }
}
