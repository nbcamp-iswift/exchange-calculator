import UIKit
import Combine

final class CalculatorViewController: UIViewController {
    private let viewModel: CalculatorViewModel
    private var cancellables = Set<AnyCancellable>()

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
        viewModel.action.send(.viewDidLoad)
    }
}

private extension CalculatorViewController {
    func configure() {
        setAttributes()
        setBindings()
    }

    func setAttributes() {
        title = "환율 계산기"
    }

    func setBindings() {
        viewModel.state.exchangeRate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] exchangeRate in
                self?.calculatorView.update(with: exchangeRate)
            }
            .store(in: &cancellables)
    }
}
