import Foundation

struct ExchangeRateCellViewModel: Hashable {
    let title: String
    let subtitle: String
    let trailingText: String

    init(from model: ExchangeRate) {
        title = model.currency
        subtitle = model.country
        trailingText = model.rate
    }
}
