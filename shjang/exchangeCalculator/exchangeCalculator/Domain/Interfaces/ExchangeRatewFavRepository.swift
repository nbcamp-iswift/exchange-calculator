import CoreData

public protocol ExchangeRatewFavRepository {
    func updateFavoriteStatus(currency: String, countryCode: String, isFavorite: Bool)
    func getFavorites() -> [ExchangeRatewFav]
    func removeAll()
    func count() -> Int?
}
