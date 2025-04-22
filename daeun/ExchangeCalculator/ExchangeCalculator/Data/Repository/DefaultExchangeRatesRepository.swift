//
//  DefaultExchangeRatesRepository.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Alamofire
import Foundation

struct DefaultExchangeRatesRepository: ExchangeRatesRepository {
    let localDataSource: LocalFavoriteDataSource

    func fetchExchangeRates() async -> Result<[ExchangeRate], AFError> {
        let url = Constant.baseURL + Constant.baseCurrency
        let result = await AF.request(url).serializingDecodable(ExchangeRatesDTO.self).result
        let favoriteMap = localDataSource.readAllData()
        return result.map {
            $0.rates.map { code, value in
                let roundedValue = value.roundedTo(digits: Constant.Digits.rate)
                return ExchangeRate(
                    currencyCode: code,
                    countryName: CurrencyCodeMapper.name(for: code),
                    value: roundedValue,
                    favorited: favoriteMap[code] ?? false
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
}
