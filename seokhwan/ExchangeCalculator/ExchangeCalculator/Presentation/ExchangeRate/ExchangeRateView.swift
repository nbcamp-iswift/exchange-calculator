import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class ExchangeRateView: UIView {
    // MARK: - Types

    enum Section {
        case main
    }

    typealias DataSource = UITableViewDiffableDataSource<Section, ExchangeRate>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Section, ExchangeRate>

    // MARK: - Properties

    let didChangeSearchText = PublishRelay<String>()
    let didTapCell = PublishRelay<ExchangeRate>()
    let didTapFavoriteButton = PublishRelay<String>()

    private var dataSource: DataSource?
    private let disposeBag = DisposeBag()

    // MARK: - UI Components

    private lazy var searchBar = UISearchBar().then {
        $0.searchBarStyle = .minimal
        $0.placeholder = "통화 검색"
    }

    private lazy var tableView = UITableView().then {
        $0.register(ExchangeRateCell.self, forCellReuseIdentifier: ExchangeRateCell.identifier)
        $0.separatorStyle = .none
        $0.rowHeight = 60
    }

    private lazy var noSearchResultsLabel = UILabel().then {
        $0.text = "검색 결과 없음"
        $0.textColor = .secondaryLabel
    }

    // MARK: - Initializers

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    // MARK: - Methods

    func update(with exchangeRates: ExchangeRates) {
        var snapshot = Snapshot()
        snapshot.appendSections([.main])
        snapshot.appendItems(exchangeRates)

        dataSource?.apply(snapshot)
        UIView.transition(
            with: noSearchResultsLabel,
            duration: 0.5,
            options: .transitionCrossDissolve
        ) { [weak self] in
            self?.noSearchResultsLabel.isHidden = !exchangeRates.isEmpty
        }
    }
}

// MARK: - Configure

private extension ExchangeRateView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setDataSource()
        setBindings()
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

    func setDataSource() {
        dataSource = DataSource(
            tableView: tableView
        ) { [weak self] tableView, indexPath, exchangeRate in
            guard let self,
                  let cell = tableView.dequeueReusableCell(
                      withIdentifier: ExchangeRateCell.identifier,
                      for: indexPath
                  ) as? ExchangeRateCell else { return UITableViewCell() }
            cell.update(with: exchangeRate)
            cell.bind(to: didTapFavoriteButton)

            return cell
        }
    }

    func setBindings() {
        searchBar.rx.text
            .orEmpty
            .bind(to: didChangeSearchText)
            .disposed(by: disposeBag)

        tableView.rx.itemSelected
            .compactMap { [weak self] indexPath -> (ExchangeRate, IndexPath)? in
                guard let exchangeRate = self?.dataSource?.itemIdentifier(for: indexPath) else {
                    return nil
                }
                return (exchangeRate, indexPath)
            }
            .do { [weak self] _, indexPath in
                self?.tableView.deselectRow(at: indexPath, animated: true)
            }
            .map(\.0)
            .bind(to: didTapCell)
            .disposed(by: disposeBag)
    }
}
