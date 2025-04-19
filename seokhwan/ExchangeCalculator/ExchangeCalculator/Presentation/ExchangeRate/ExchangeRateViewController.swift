import UIKit
import Combine

final class ExchangeRateViewController: UIViewController {
    private let viewModel: ExchangeRateViewModel
    private let container: AppDIContainer
    private var cancellables = Set<AnyCancellable>()

    private lazy var exchangeRateView = ExchangeRateView()

    init(viewModel: ExchangeRateViewModel, container: AppDIContainer) {
        self.viewModel = viewModel
        self.container = container
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = exchangeRateView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewModel.action.send(.viewDidLoad)
    }
}

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
            .receive(on: DispatchQueue.main)
            .sink { [weak self] exchangeRates in
                self?.exchangeRateView.update(with: exchangeRates)
            }
            .store(in: &cancellables)

        viewModel.state.selectedExchangeRate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] exchangeRate in
                guard let viewController = self?.container.makeCalculatorViewController(
                    with: exchangeRate
                ) else { return }
                self?.navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: &cancellables)

        viewModel.state.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.showAlert(title: "오류", message: "데이터를 불러올 수 없습니다")
            }
            .store(in: &cancellables)

        exchangeRateView.searchTextDidChangePublisher
            .sink { [weak self] searchText in
                self?.viewModel.action.send(.searchTextDidChange(searchText: searchText))
            }
            .store(in: &cancellables)

        exchangeRateView.cellDidTapPublisher
            .sink { [weak self] exchangeRate in
                self?.viewModel.action.send(.cellDidTap(exchangeRate: exchangeRate))
            }
            .store(in: &cancellables)
    }
}
