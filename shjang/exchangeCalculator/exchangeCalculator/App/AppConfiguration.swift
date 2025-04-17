import Foundation

final class AppConfiguration {
    lazy var apiBaseURL: String = {
        guard let apiBaseURL = Bundle.main.object(forInfoDictionaryKey: "ApiBaseURL")
            as? String
        else {
            fatalError("ApiBaseURL is not defined in Info.plist")
        }
        return apiBaseURL
    }()
}
