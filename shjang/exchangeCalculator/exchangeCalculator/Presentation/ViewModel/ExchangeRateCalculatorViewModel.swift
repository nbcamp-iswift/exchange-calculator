import Foundation

final class ExchangeRateCalculatorViewModel {
    let currency: String
    let countryName: String
    let exchangeRate: String

    @Published private(set) var result: String = ""

    init(currency: String, countryName: String, exchangeRate: String) {
        self.currency = currency
        self.countryName = countryName
        self.exchangeRate = exchangeRate
    }

    func convert(amount: Double) {
        guard let rate = Double(exchangeRate) else {
            result = ""
            return
        }
        result = String(format: "%.2f", amount * rate)
    }
}
