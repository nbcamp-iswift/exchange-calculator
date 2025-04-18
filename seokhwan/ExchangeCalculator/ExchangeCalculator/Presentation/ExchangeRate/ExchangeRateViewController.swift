import UIKit
import Combine

final class ExchangeRateViewController: UIViewController {
    private lazy var viewModel = ExchangeRateViewModel(
        viewDidLoadPublisher,
        searchTextDidChangePublisher
    )
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private let searchTextDidChangeSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    var viewDidLoadPublisher: AnyPublisher<Void, Never> {
        viewDidLoadSubject.eraseToAnyPublisher()
    }

    var searchTextDidChangePublisher: AnyPublisher<String, Never> {
        searchTextDidChangeSubject.eraseToAnyPublisher()
    }

    private lazy var exchangeRateView = ExchangeRateView()

    override func loadView() {
        view = exchangeRateView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewDidLoadSubject.send(())
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
        viewModel.exchangeRatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] exchangeRates in
                self?.exchangeRateView.update(with: exchangeRates)
            }
            .store(in: &cancellables)

        viewModel.errorMessagePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.showAlert(title: "오류", message: "데이터를 불러올 수 없습니다")
            }
            .store(in: &cancellables)

        exchangeRateView.searchTextDidChangePublisher
            .sink { [weak self] searchText in
                self?.searchTextDidChangeSubject.send(searchText)
            }
            .store(in: &cancellables)
    }
}
