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
        configure()
    }
}

extension ListViewController {
    private func configure() {
        configureDataSource()
        setBindings()
        viewModel.loadItems()
    }

    private func configureDataSource() {
        dataSource = .init(tableView: listView.tableView) { tableView, indexPath, item
            -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ListCell.reuseIdentifier,
                for: indexPath
            ) as? ListCell

            guard case let ListItem.rate(exchangeRate) = item else { return nil }
            cell?.updateCell(for: exchangeRate)

            return cell
        }

        var initialSnapshot = NSDiffableDataSourceSnapshot<ListSection, ListItem>()
        initialSnapshot.appendSections([.list])

        dataSource?.apply(initialSnapshot)
    }

    private func setBindings() {
        viewModel.$rates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rates in
                guard let self, var snapshot = dataSource?.snapshot() else { return }
                let items = rates.map { ListItem.rate($0) }
                snapshot.appendItems(items, toSection: .list)
                dataSource?.apply(snapshot)
            }
            .store(in: &cancellables)

        viewModel.$error
            .receive(on: DispatchQueue.main)
            .filter { $0 }
            .sink { [weak self] _ in
                self?.showAlert()
            }
            .store(in: &cancellables)
    }

    private func showAlert() {
        let alertView = UIAlertController(
            title: Constant.Alert.title,
            message: Constant.Alert.message,
            preferredStyle: .alert
        )

        let confirmAction = UIAlertAction(title: Constant.Alert.confirm, style: .default)
        alertView.addAction(confirmAction)

        present(alertView, animated: true)
    }
}
