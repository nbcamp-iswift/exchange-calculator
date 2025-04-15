import UIKit
import SnapKit

final class MainView: UIView {
    enum Section {
        case main
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, ExchangeRate>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ExchangeRate>

    private var dataSource: DataSource?

    private lazy var tableView = UITableView().configure {
        $0.register(ExchangeRateCell.self)
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
        addSubviews()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .background

        dataSource = DataSource(tableView: tableView) { tableView, indexPath, exchangeRate in
            guard let cell = tableView.dequeueReusableCell(
                withIdentifier: ExchangeRateCell.identifier,
                for: indexPath
            ) as? ExchangeRateCell else { return UITableViewCell() }
            cell.update(with: exchangeRate)

            return cell
        }
    }

    func addSubviews() {
        addSubview(tableView)
    }

    func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
