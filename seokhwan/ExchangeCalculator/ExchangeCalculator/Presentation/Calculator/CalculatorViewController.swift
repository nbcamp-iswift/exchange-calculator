import UIKit

final class CalculatorViewController: UIViewController {
    private let viewModel: CalculatorViewModel

    private lazy var calculatorView = CalculatorView()

    init(viewModel: CalculatorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

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
