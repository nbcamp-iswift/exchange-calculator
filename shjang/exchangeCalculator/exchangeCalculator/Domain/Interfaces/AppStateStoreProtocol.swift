import Foundation

protocol AppStateStore {
    func saveLastScreen(type: LastScreenType, selectedCurrency: String?)
    func loadLastScreen() -> LastScreenInfo
}
