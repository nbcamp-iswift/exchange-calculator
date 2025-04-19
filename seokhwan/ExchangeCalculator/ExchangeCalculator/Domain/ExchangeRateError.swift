import Foundation

enum ExchangeRateError: LocalizedError {
    // TODO: Error Case 구체화해야 함
    case emptyInput
    case invalidInput
    case unknownError

    var errorDescription: String? {
        switch self {
        case .emptyInput:
            return "금액을 입력해 주세요"
        case .invalidInput:
            return "올바른 숫자를 입력해 주세요"
        case .unknownError:
            return "unknownError"
        }
    }
}
