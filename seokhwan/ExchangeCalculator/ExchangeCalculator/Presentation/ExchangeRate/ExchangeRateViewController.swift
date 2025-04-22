import UIKit
import RxSwift
import RxRelay

final class ExchangeRateViewController: UIViewController {

    // MARK: - Properties

    private let viewModel: ExchangeRateViewModel
    private let container: AppDIContainer
    private let disposeBag = DisposeBag()

    private lazy var exchangeRateView = ExchangeRateView()

    // MARK: - Initializers

    init(viewModel: ExchangeRateViewModel, container: AppDIContainer) {
        self.viewModel = viewModel
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Lifecycle Methods

    override func loadView() {
        view = exchangeRateView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.action.accept(.viewDidLoad)
    }
}

// MARK: - Configure

private extension ExchangeRateViewController {
    func configure() {
        setAttributes()
        setBindings()
    }

    func setAttributes() {
        title = "환율 정보"
    }

    func setBindings() {
        viewModel.state.filteredExchangeRates
            .observe(on: MainScheduler.instance)
            .bind { [weak self] exchangeRates in
                self?.exchangeRateView.update(with: exchangeRates)
            }
            .disposed(by: disposeBag)

        viewModel.state.selectedExchangeRate
            .observe(on: MainScheduler.instance)
            .bind { [weak self] exchangeRate in
                guard let viewController = self?.container.makeCalculatorViewController(
                    with: exchangeRate
                ) else { return }

                self?.navigationController?.pushViewController(viewController, animated: true)
            }
            .disposed(by: disposeBag)

        viewModel.state.errorMessage
            .observe(on: MainScheduler.instance)
            .bind { [weak self] message in
                self?.presentErrorAlert(with: message)
            }
            .disposed(by: disposeBag)

        exchangeRateView.didChangeSearchText
            .bind { [weak self] searchText in
                self?.viewModel.action.accept(.didChangeSearchText(searchText: searchText))
            }
            .disposed(by: disposeBag)

        exchangeRateView.didTapCell
            .bind { [weak self] exchangeRate in
                self?.viewModel.action.accept(.didTapCell(exchangeRate: exchangeRate))
            }
            .disposed(by: disposeBag)

        exchangeRateView.didTapFavoriteButton
            .bind { [weak self] currency in
                self?.viewModel.action.accept(.didTapFavoriteButton(currency: currency))
            }
            .disposed(by: disposeBag)
    }
}
