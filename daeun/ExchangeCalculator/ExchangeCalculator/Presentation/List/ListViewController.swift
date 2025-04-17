//
//  ListViewController.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/15/25.
//

import Combine
import UIKit

final class ListViewController: UIViewController {
    enum ListSection: Hashable {
        case list
    }

    enum ListItem: Hashable {
        case rate(ExchangeRate)
    }

    // MARK: - Properties

    private let viewModel: ListViewModel
    private var dataSource: UITableViewDiffableDataSource<ListSection, ListItem>?
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Components

    private let listView = ListView()

    // MARK: - Life Cycles

    init(listViewModel: ListViewModel) {
        viewModel = listViewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func loadView() {
        view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
        viewModel.loadItems()
        setBindings()
    }
}

// MARK: DataSource

extension ListViewController {
    private func configureDataSource() {
        dataSource = .init(tableView: listView.tableView) { tableView, indexPath, item
            -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ListCell.reuseIdentifier,
                for: indexPath
            ) as? ListCell

            guard case let ListItem.rate(exchangeRate) = item else { return nil }
            cell?.updateCell(for: exchangeRate)
            cell?.selectionStyle = .none

            return cell
        }

        var initialSnapshot = NSDiffableDataSourceSnapshot<ListSection, ListItem>()
        initialSnapshot.appendSections([.list])

        dataSource?.apply(initialSnapshot, animatingDifferences: true)
    }
}

// MARK: Set Bindings

extension ListViewController {
    private func setBindings() {
        viewModel.$rates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rates in
                guard let self, var snapshot = dataSource?.snapshot() else { return }
                let items = rates.map { ListItem.rate($0) }
                snapshot.appendItems(items, toSection: .list)
                dataSource?.apply(snapshot, animatingDifferences: true)
            }
            .store(in: &cancellables)
    }
}
