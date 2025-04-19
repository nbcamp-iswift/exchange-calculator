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
                guard let self else { return }
                exchangeRateView.update(with: exchangeRates)
            }
            .store(in: &cancellables)

        viewModel.state.selectedExchangeRate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] exchangeRate in
                guard let self else { return }
                let viewController = container.makeCalculatorViewController(with: exchangeRate)

                navigationController?.pushViewController(viewController, animated: true)
            }
            .store(in: &cancellables)

        viewModel.state.errorMessage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] message in
                guard let self else { return }
                presentErrorAlert(with: message)
            }
            .store(in: &cancellables)

        exchangeRateView.searchTextDidChangePublisher
            .sink { [weak self] searchText in
                guard let self else { return }
                viewModel.action.send(.searchTextDidChange(searchText: searchText))
            }
            .store(in: &cancellables)

        exchangeRateView.cellDidTapPublisher
            .sink { [weak self] exchangeRate in
                guard let self else { return }
                viewModel.action.send(.cellDidTap(exchangeRate: exchangeRate))
            }
            .store(in: &cancellables)
    }
}
