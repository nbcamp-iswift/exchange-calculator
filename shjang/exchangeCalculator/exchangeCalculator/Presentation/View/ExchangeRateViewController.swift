import UIKit
import Combine
import Then
import SnapKit

final class ExchangeRateViewController: UIViewController {
    private var viewModel: ExchangeRateViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var tableView = UITableView().then {
        $0.dataSource = self
        $0.delegate = self
        $0.rowHeight = 40
        $0.register(
            CustomTableViewCell.self,
            forCellReuseIdentifier: CustomTableViewCell.identifier
        )
    }

    init(viewModel: ExchangeRateViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }

    private func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    private func setAttributes() {
        view.backgroundColor = .white
    }

    private func setHierarchy() {
        view.addSubview(tableView)
    }

    private func setBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loaded:
                    self?.tableView.reloadData()
                case .failed(let msg):
                    self?.presentAlert(msg: msg)
                case .idle, .loading:
                    break
                }
            }
            .store(in: &cancellables)
    }

    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func presentAlert(msg: String) {
        let alert = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

extension ExchangeRateViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        viewModel.getNumberOfRates()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: CustomTableViewCell.identifier,
            for: indexPath
        ) as? CustomTableViewCell else {
            fatalError("Failed to Cast to CustomTableViewCell")
        }

        let rate = viewModel.getRate(at: indexPath.row)
        cell.update(with: rate.currency, with: rate.rate)
        return cell
    }
}

extension ExchangeRateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath) as? CustomTableViewCell)?.animatedPressed {}
    }
}
