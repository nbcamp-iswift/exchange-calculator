import UIKit
import SnapKit

final class MainView: UIView {
    enum Section {
        case main
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, ExchangeRate>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ExchangeRate>

    private var dataSource: DataSource?

    private lazy var searchBar = UISearchBar().configure {
        $0.removeBorder()
        $0.placeholder = "통화 검색"
    }

    private lazy var tableView = UITableView().configure {
        $0.register(ExchangeRateCell.self)
        $0.rowHeight = 60
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
        snapshot.appendItems(exchangeRates.rates)

        dataSource?.apply(snapshot)
    }
}

private extension MainView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setDataSource()
    }

    func setAttributes() {
        backgroundColor = .background
    }

    func setHierarchy() {
        addSubviews(searchBar, tableView)
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
