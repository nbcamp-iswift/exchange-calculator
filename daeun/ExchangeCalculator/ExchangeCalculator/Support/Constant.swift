//
//  Constant.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import Foundation

enum Constant {
    static let baseURL = "https://open.er-api.com/v6/latest/"
    static let baseCurrency = "USD"

    enum FontSize {
        static let medium: CGFloat = 16
        static let small: CGFloat = 14
    }

    enum Spacing {
        static let cellVertical: CGFloat = 12
        static let cellHorizontal: CGFloat = 16
        static let labelStack: CGFloat = 4
    }

    enum Size {
        static let cellHeight: CGFloat = 60
        static let rateLabelWidth: CGFloat = 120
    }

    enum Digits {
        static let rate: Int = 4
    }

    enum Alert {
        static let title = "오류"
        static let message = "데이터를 불러올 수 없습니다."
        static let confirm = "확인"
    }
    enum Title {
        static let exchangeInfo = "환율 정보"
    }

    enum Text {
        static let noMatch = "검색 결과 없음"
    }
}
