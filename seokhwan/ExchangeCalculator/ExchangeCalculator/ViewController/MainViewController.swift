import UIKit

final class MainViewController: UIViewController {
    private lazy var mainView = MainView()

    override func loadView() {
        view = mainView
    }
}
