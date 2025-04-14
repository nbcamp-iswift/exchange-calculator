import UIKit
import Combine
import Alamofire

final class MainViewController: UIViewController {
    private lazy var viewModel = MainViewModel(viewDidLoadPublisher)
    private let viewDidLoadSubject = PassthroughSubject<Void, Never>()
    private var cancellables = Set<AnyCancellable>()

    var viewDidLoadPublisher: AnyPublisher<Void, Never> {
        return viewDidLoadSubject.eraseToAnyPublisher()
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
        bind()
    }

    func bind() {
        viewModel.exchangeRatesPublisher
            .receive(on: DispatchQueue.main)
            .sink { exchangeRates in
                // TODO: TableView에 데이터 갱신
            }
            .store(in: &cancellables)

        viewModel.errorPublisher
            .receive(on: DispatchQueue.main)
            .sink { error in
                // TODO: Alert 띄우기
            }
            .store(in: &cancellables)
    }
}
