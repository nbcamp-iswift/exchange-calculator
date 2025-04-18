import Foundation

final class ExchangeRateCalculatorViewModel {
    private let currency: String
    private let countryName: String
    private let exchangeRate: String

    @Published private(set) var result: String = ""

    init(currency: String, countryName: String, exchangeRate: String) {
        self.currency = currency
        self.countryName = countryName
        self.exchangeRate = exchangeRate
    }

    func getCurrency() -> String {
        currency
    }

    func getCountryName() -> String {
        countryName
    }

    func getExchangeRate() -> String {
        exchangeRate
    }

    func convert(amount: Double) {
        guard let rate = Double(exchangeRate) else {
            result = ""
            return
        }
        result = String(format: "%.2f", amount * rate)
    }
}
