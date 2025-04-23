import UIKit
import RxSwift

final class CalculatorViewController: UIViewController {
    // MARK: - Properties

    private let coordinator: Coordinator
    private let viewModel: CalculatorViewModel
    private let disposeBag = DisposeBag()

    private lazy var calculatorView = CalculatorView()

    // MARK: - Initializers

    init(coordinator: Coordinator, viewModel: CalculatorViewModel) {
        self.coordinator = coordinator
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle Methods

    override func loadView() {
        view = calculatorView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.action.accept(.viewDidLoad)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Task {
            await coordinator.updateLastScreen(
                to: .calculatorView,
                with: viewModel.state.exchangeRate.value
            )
        }
    }
}

// MARK: - Configure

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
            .observe(on: MainScheduler.instance)
            .bind { [weak self] exchangeRate in
                guard let self,
                      let exchangeRate else { return }
                calculatorView.update(with: exchangeRate)
            }
            .disposed(by: disposeBag)

        viewModel.state.convertedAmount
            .observe(on: MainScheduler.instance)
            .bind { [weak self] result in
                self?.calculatorView.update(with: result)
            }
            .disposed(by: disposeBag)

        viewModel.state.errorMessage
            .observe(on: MainScheduler.instance)
            .bind { [weak self] message in
                self?.presentErrorAlert(with: message)
            }
            .disposed(by: disposeBag)

        calculatorView.didTapConvertButton
            .bind { [weak self] text in
                self?.viewModel.action.accept(.convert(input: text))
            }
            .disposed(by: disposeBag)
    }
}
