import Foundation

enum LastScreenType: String {
    case exchangeRateView = "ExchangeRateView"
    case calculatorView = "CalculatorView"
}

struct LastScreen {
    let type: LastScreenType
    let exchangeRate: ExchangeRate?
}
