import UIKit
import Combine
import Then
import SnapKit

final class ExchangeRateView: UIView {
    enum Section {
        case main
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, ExchangeRate>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ExchangeRate>

    private var dataSource: DataSource?
    private let searchTextDidChangeSubject = PassthroughSubject<String, Never>()
    private let cellDidTapSubject = PassthroughSubject<ExchangeRate, Never>()
    private var cancellables = Set<AnyCancellable>()

    var searchTextDidChangePublisher: AnyPublisher<String, Never> {
        searchTextDidChangeSubject.eraseToAnyPublisher()
    }

    var cellDidTapPublisher: AnyPublisher<ExchangeRate, Never> {
        cellDidTapSubject.eraseToAnyPublisher()
    }

    private lazy var searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.placeholder = "통화 검색"
    }

    private lazy var tableView = UITableView().then {
        $0.register(ExchangeRateCell.self)
        $0.rowHeight = 60
    }

    private lazy var noSearchResultsLabel = UILabel().then {
        $0.text = "검색 결과 없음"
        $0.textColor = .gray
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with exchangeRates: ExchangeRates) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(exchangeRates)

        dataSource?.apply(snapshot)
        UIView.transition(
            with: noSearchResultsLabel,
            duration: 0.5,
            options: .transitionCrossDissolve
        ) {
            self.noSearchResultsLabel.isHidden = !exchangeRates.isEmpty
        }
    }
}

private extension ExchangeRateView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setDelegate()
        setDataSource()
    }

    func setAttributes() {
        backgroundColor = .background
    }

    func setHierarchy() {
        addSubviews(searchBar, tableView, noSearchResultsLabel)
    }

    func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }

        noSearchResultsLabel.snp.makeConstraints { make in
            make.center.equalTo(tableView.snp.center)
        }
    }

    func setDelegate() {
        searchBar.delegate = self
        tableView.delegate = self
    }

    func setDataSource() {
        dataSource = DataSource(tableView: tableView) { tableView, indexPath, exchangeRate in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ExchangeRateCell.identifier,
                for: indexPath
            ) as? ExchangeRateCell else { return UITableViewCell() }
            cell.update(with: exchangeRate)

            return cell
        }
    }
}

extension ExchangeRateView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchTextDidChangeSubject.send(searchText)
    }
}

extension ExchangeRateView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let exchangeRate = dataSource?.itemIdentifier(for: indexPath) else { return }

        cellDidTapSubject.send(exchangeRate)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
