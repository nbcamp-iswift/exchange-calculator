import Foundation

enum ExchangeRateError: LocalizedError {
    case networkError
    case storageError
    case emptyInput
    case invalidNumber

    var errorDescription: String? {
        switch self {
        case .networkError:
            return "Network 오류가 발생했습니다"
        case .storageError:
            return "Storage 오류가 발생했습니다"
        case .emptyInput:
            return "금액을 입력해 주세요"
        case .invalidNumber:
            return "올바른 숫자를 입력해 주세요"
        }
    }
}
