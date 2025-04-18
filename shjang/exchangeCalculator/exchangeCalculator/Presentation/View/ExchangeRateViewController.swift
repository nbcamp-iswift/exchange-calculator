import UIKit
import Combine
import Then
import SnapKit

final class ExchangeRateViewController: UIViewController {
    private enum Section { case main }
    private var viewModel: ExchangeRateViewModel
    private var cancellables = Set<AnyCancellable>()
    private var dataSource: UITableViewDiffableDataSource<Section, ExchangeRateCellViewModel>?

    private lazy var tableView = UITableView().then {
        $0.delegate = self
        $0.rowHeight = 60
        $0.register(
            ExchangeRateTableViewCell.self,
            forCellReuseIdentifier: ExchangeRateTableViewCell.identifier
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
        setDataSource()
        setBindings()
    }

    private func setAttributes() {
        view.backgroundColor = .white
    }

    private func setHierarchy() {
        view.addSubview(searchBar)
        view.addSubview(tableView)
    }

    private func setDataSource() {
        dataSource = configureDataSource()
    }

    private func setBindings() {
        viewModel.$state
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                switch state {
                case .loaded(let viewModel):
                    self?.updateSnapshot(with: viewModel)
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

    private func configureDataSource()
        -> UITableViewDiffableDataSource<Section, ExchangeRateCellViewModel> {
        UITableViewDiffableDataSource(tableView: tableView) { tableView, indexPath, item in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ExchangeRateTableViewCell.identifier,
                for: indexPath
            ) as? ExchangeRateTableViewCell else {
                fatalError("Failed to Cast to CustomTableView Cell")
            }
            cell.update(with: item.title, with: item.subtitle, with: item.trailingText)
            return cell
        }
    }

    private func updateSnapshot(with item: [ExchangeRateCellViewModel]) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ExchangeRateCellViewModel>()
        snapshot.appendSections([.main])
        snapshot.appendItems(item)
        dataSource?.apply(snapshot, animatingDifferences: true)

        tableView.backgroundView = item.isEmpty ? makeEmptyView() : nil
    }
}

extension ExchangeRateViewController: UISearchBarDelegate {
    func searchBar(_: UISearchBar, textDidChange searchText: String) {
        viewModel.filter(with: searchText)
    }

    func searchBarSearchButtonClicked(_: UISearchBar) {
        searchBar.text = nil
        searchBar.resignFirstResponder()
    }
}

extension ExchangeRateViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        (tableView.cellForRow(at: indexPath) as? ExchangeRateTableViewCell)?.animatedPressed {}

        guard let item = dataSource?.itemIdentifier(for: indexPath) else { return }

        let calculatorViewModel = ExchangeRateCalculatorViewModel(
            currency: item.title,
            countryName: item.subtitle,
            exchangeRate: item.trailingText
        )

        let calculatorViewController = ExchangeRateCalculatorViewController(
            viewModel: calculatorViewModel)

        navigationController?.pushViewController(
            calculatorViewController,
            animated: true
        )
    }
}

extension ExchangeRateViewController {
    private func makeEmptyView() -> UIView {
        let label = UILabel()
        label.text = "No data found"
        label.textColor = .systemGray
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }
}
