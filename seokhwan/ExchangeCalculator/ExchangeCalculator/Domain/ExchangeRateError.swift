import Foundation

enum ExchangeRateError: LocalizedError {
    // TODO: Error Case 구체화해야 함
    case unknownError

    var errorDescription: String? {
        switch self {
        case .unknownError:
            return "unknownError"
        }
    }
}
