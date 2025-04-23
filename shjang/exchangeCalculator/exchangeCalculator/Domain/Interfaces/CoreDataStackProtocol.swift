import CoreData

protocol CoreDataStackProtocol {
    func updateFavoriteStatus(currency: String, countryCode: String, isFavorite: Bool)
    func getFavorites() -> [ExchangeRatewFav]
    func getAllExchangedRate() -> [ExchangeRatewFav]
    func saveOrUpdate(rate: ExchangeRate, isFavorite: Bool)
    func removeAll()
    func count() -> Int?
}
