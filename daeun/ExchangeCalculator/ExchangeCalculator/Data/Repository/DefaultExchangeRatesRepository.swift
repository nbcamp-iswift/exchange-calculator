//
//  DefaultExchangeRatesRepository.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Alamofire
import Foundation

struct DefaultExchangeRatesRepository: ExchangeRatesRepository {
    let favoriteDataSource: LocalFavoriteDataSource
    let rateChangeDataSource: LocalRateChangeDataSource
    let lastViewedDataSource: LocalLastViewedDataSource

    func fetchExchangeRates() async -> Result<[ExchangeRate], AFError> {
        let url = Constant.baseURL + Constant.baseCurrency
        let result = await AF.request(url).serializingDecodable(ExchangeRatesDTO.self).result
        let favoriteMap = favoriteDataSource.readAllData()
        let cachedRateMap = rateChangeDataSource.readAllData()

        return result.map { dto in
            updateCacheIfNeeded(on: dto)

            return dto.rates.map { code, value in
                let roundedValue = value.roundedTo(digits: Constant.Digits.rate)
                return ExchangeRate(
                    currencyCode: code,
                    countryName: CurrencyCodeMapper.name(for: code),
                    value: roundedValue,
                    favorited: favoriteMap[code] ?? false,
                    lastValue: cachedRateMap[code] ?? roundedValue
                )
            }
            .sorted {
                if $0.favorited == $1.favorited {
                    $0.currencyCode < $1.currencyCode
                } else {
                    $0.favorited && !$1.favorited
                }
            }
        }
    }

    func updateCacheIfNeeded(on currentData: ExchangeRatesDTO) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss Z"

        guard let currentDate = formatter.date(from: currentData.lastUpdated) else { return }
        guard let cachedDate = rateChangeDataSource.readLastUpdatedDate() else {
            rateChangeDataSource.updateData(to: currentData.rates, on: currentDate)
            return
        }
        if currentDate.isAfterOneDay(comparedTo: cachedDate) {
            rateChangeDataSource.updateData(to: currentData.rates, on: currentDate)
        }
    }

    func saveLastViewedExchangeRate(code: String) {
        lastViewedDataSource.addData(code: code)
    }

    func deleteLastViewedExchangeRate() {
        lastViewedDataSource.deleteData()
    }
}
