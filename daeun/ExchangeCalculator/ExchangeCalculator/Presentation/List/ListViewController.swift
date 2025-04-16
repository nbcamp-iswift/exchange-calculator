//
//  ListViewController.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/15/25.
//

import UIKit

final class ListViewController: UIViewController {
    enum ListSection: Hashable {
        case list
    }

    enum ListItem: Hashable {
        case rate(ExchangeRate)
    }

    // MARK: - Properties

    private var dataSource: UITableViewDiffableDataSource<ListSection, ListItem>?

    // MARK: - Components

    private let listView = ListView()

    // MARK: - Life Cycles

    override func loadView() {
        view = listView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureDataSource()
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
