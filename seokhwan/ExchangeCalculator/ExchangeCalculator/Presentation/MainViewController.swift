import UIKit
import Combine
import Alamofire

final class MainViewController: UIViewController {
    private lazy var viewModel = MainViewModel(viewDidLoadPublisher)
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    var viewDidLoadPublisher: AnyPublisher<Void, Never> {
        viewDidLoadSubject.eraseToAnyPublisher()
    }

    private lazy var mainView = MainView()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        viewDidLoadSubject.send(())
    }
}

private extension MainViewController {
    func configure() {
        setBindings()
    }

    func setBindings() {
        viewModel.exchangeRatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] exchangeRates in
                self?.mainView.update(with: exchangeRates)
            }
            .store(in: &cancellables)

        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.showAlert(title: "오류", message: "데이터를 불러올 수 없습니다")
            }
            .store(in: &cancellables)
    }
}
