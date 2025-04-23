import Foundation

enum Direction {
    case up
    case down
}

struct ExchangeRateTableViewCellModel: Hashable {
    let id: String
    let title: String
    let subtitle: String
    let trailingText: String
    var isFavorite: Bool
    let direction: Direction?

    init(
        from model: ExchangeRate,
        isFavorite: Bool = false,
        direction: Direction? = nil
    ) {
        id = model.currency
        title = model.currency
        subtitle = model.country
        trailingText = model.rate
        self.isFavorite = isFavorite
        self.direction = direction
    }

    static func == (
        lhs: ExchangeRateTableViewCellModel,
        rhs: ExchangeRateTableViewCellModel
    ) -> Bool {
        lhs.id == rhs.id &&
            lhs.title == rhs.title &&
            lhs.subtitle == rhs.subtitle &&
            lhs.trailingText == rhs.trailingText &&
            lhs.isFavorite == rhs.isFavorite &&
            lhs.direction == rhs.direction
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(subtitle)
        hasher.combine(trailingText)
        hasher.combine(isFavorite)
        hasher.combine(direction)
    }
}
