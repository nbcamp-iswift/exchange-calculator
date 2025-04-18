import UIKit

final class CalculatorViewController: UIViewController {
    private lazy var viewModel = CalculatorViewModel()

    private lazy var calculatorView = CalculatorView()

    override func loadView() {
        view = calculatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension CalculatorViewController {
    func configure() {
        setAttributes()
    }

    func setAttributes() {
        title = "환율 계산기"
    }
}
