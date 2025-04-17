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
        $0.rowHeight = 60
        $0.register(
            CustomTableViewCell.self,
            forCellReuseIdentifier: CustomTableViewCell.identifier
        )
    }

    private lazy var searchBar = UISearchBar().then {
        $0.delegate = self
        $0.searchBarStyle = .minimal
        $0.placeholder = "Search currency"
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
        view.addSubview(searchBar)
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
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.trailing.leading.equalTo(view.safeAreaLayoutGuide)
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.trailing.leading.bottom.equalTo(view.safeAreaLayoutGuide)
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

        let exchangeRate = viewModel.getExchangeRate(at: indexPath.row)
        cell.update(
            with: exchangeRate.currency,
            with: exchangeRate.country,
            with: exchangeRate.rate,
        )
        return cell
    }
}

extension ExchangeRateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath) as? CustomTableViewCell)?.animatedPressed {}
    }
}

extension ExchangeRateViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        tableView.reloadData()
    }

    func searchBarSearchButtonClicked(_: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
}
