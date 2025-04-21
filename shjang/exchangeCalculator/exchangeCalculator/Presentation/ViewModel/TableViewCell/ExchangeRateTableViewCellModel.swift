import Foundation

struct ExchangeRateTableViewCellModel: Hashable {
    let identifier: String
    let title: String
    let subtitle: String
    let trailingText: String
    var isFavorite: Bool

    init(from model: ExchangeRate, isFavorite: Bool = false) {
        title = model.currency
        subtitle = model.country
        trailingText = model.rate
        self.isFavorite = isFavorite
        identifier = "\(model.currency)-\(model.country)"
    }

    static func == (
        lhs: ExchangeRateTableViewCellModel,
        rhs: ExchangeRateTableViewCellModel
    ) -> Bool {
        lhs.identifier == rhs.identifier &&
            lhs.title == rhs.title &&
            lhs.subtitle == rhs.subtitle &&
            lhs.trailingText == rhs.trailingText &&
            lhs.isFavorite == rhs.isFavorite
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
        hasher.combine(title)
        hasher.combine(subtitle)
        hasher.combine(trailingText)
        hasher.combine(isFavorite)
    }
}
