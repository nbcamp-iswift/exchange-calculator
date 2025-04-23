import Foundation

enum LastScreenType: String {
    case table
    case calculator
}

public struct LastScreenInfo {
    let screen: LastScreenType
    let selectedCurrency: String?
}
