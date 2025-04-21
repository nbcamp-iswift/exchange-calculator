import Foundation

enum ExchangeRateError: LocalizedError {
    case dataLoadFailed
    case emptyInput
    case invalidNumber

    var errorDescription: String? {
        switch self {
        case .dataLoadFailed:
            return "데이터를 불러올 수 없습니다"
        case .emptyInput:
            return "금액을 입력해 주세요"
        case .invalidNumber:
            return "올바른 숫자를 입력해 주세요"
        }
    }
}
