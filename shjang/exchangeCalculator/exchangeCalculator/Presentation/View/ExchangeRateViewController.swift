import UIKit
import Combine
import SnapKit

final class ExchangeRateViewController: UIViewController {
    private var viewModel: ExchangeRateViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.dataSource = self
        tableView.rowHeight = 20
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "RateCell")
        return tableView
    }()

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
            make.top.leading.trailing.bottom.equalToSuperview()
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
        let rate = viewModel.getRate(at: indexPath.row)
        let cell = tableView.dequeueReusableCell(
            withIdentifier: "RateCell",
            for: indexPath
        )
        cell.textLabel?.text = "\(rate.currency): \(String(format: "%.4f", rate.rate))"
        return cell
    }
}
