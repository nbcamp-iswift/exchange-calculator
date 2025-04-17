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

    enum Spacing {
        static let cellVertical: CGFloat = 12
        static let cellHorizontal: CGFloat = 20
    }

    enum Digits {
        static let rate: Int = 4
    }

    enum Alert {
        static let title = "오류"
        static let message = "데이터를 불러올 수 없습니다."
        static let confirm = "확인"
    }

    enum Text {
        static let noMatch = "검색 결과 없음"
    }
}
