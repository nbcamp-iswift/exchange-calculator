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
                self?.calculatorView.update(exchangeRate: exchangeRate)
            }
            .store(in: &cancellables)

        viewModel.state.convertedAmount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.calculatorView.update(result: result)
            }
            .store(in: &cancellables)

        viewModel.state.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                self?.showAlert(title: "오류", message: message)
            }
            .store(in: &cancellables)

        calculatorView.convertButtonDidTapPublisher
            .sink { [weak self] amount in
                self?.viewModel.action.send(.convert(input: amount))
            }
            .store(in: &cancellables)
    }
}
