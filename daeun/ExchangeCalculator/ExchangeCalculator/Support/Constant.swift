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
        static let extraLarge: CGFloat = 24
        static let large: CGFloat = 20
        static let medium: CGFloat = 16
        static let small: CGFloat = 14
    }

    enum Spacing {
        static let cellVertical: CGFloat = 12
        static let detailvertical: CGFloat = 32
        static let elementVertical: CGFloat = 24
        static let cellHorizontal: CGFloat = 16
        static let detailHorizontal: CGFloat = 16
        static let labelStack: CGFloat = 4
    }

    enum Size {
        static let cellHeight: CGFloat = 60
        static let fieldHeight: CGFloat = 44
        static let rateLabelWidth: CGFloat = 120
    }

    enum Config {
        static let buttonCornerRadius: CGFloat = 8
    }

    enum Digits {
        static let rate: Int = 4
    }

    enum Alert {
        static let title = "오류"
        static let fetchErrorMessage = "데이터를 불러올 수 없습니다"
        static let confirm = "확인"
    }

    enum Title {
        static let exchangeInfo = "환율 정보"
        static let exchangeCalc = "환율 계산기"
    }

    enum Text {
        static let noMatch = "검색 결과 없음"
        static let typeAmount = "금액을 입력하세요"
        static let calcExchange = "환율 계산"
        static let calcResult = "계산 결과가 여기에 표시됩니다"
    }
}
