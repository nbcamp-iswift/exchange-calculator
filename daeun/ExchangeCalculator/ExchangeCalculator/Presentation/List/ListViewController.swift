//
//  ListViewController.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/15/25.
//

import Combine
import CombineCocoa
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
        viewModel.action.send(.viewDidLoad)
        configure()
    }
}

// MARK: - Methods

extension ListViewController {
    private func configure() {
        setAttributes()
        setDataSource()
        setBindings()
    }

    private func setAttributes() {
        title = Constant.Title.exchangeInfo
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setDataSource() {
        dataSource = .init(
            tableView: listView.tableView
        ) { tableView, indexPath, item -> UITableViewCell? in
            let cell = tableView.dequeueReusableCell(
                withIdentifier: ListCell.reuseIdentifier,
                for: indexPath
            ) as? ListCell

            guard let cell, case let ListItem.rate(exchangeRate) = item else { return nil }

            cell.updateCell(for: exchangeRate)
            cell.isSelectedFavoriteButton
                .sink { [weak self] _ in
                    self?.viewModel.action.send(.didTapFavoriteButton(indexPath.row))
                }
                .store(in: &cell.cancellables)

            return cell
        }

        var initialSnapshot = NSDiffableDataSourceSnapshot<ListSection, ListItem>()
        initialSnapshot.appendSections([.list])

        dataSource?.apply(initialSnapshot)
    }

    private func setBindings() {
        listView.searchBar.textDidChangePublisher
            .sink { [weak self] text in
                self?.viewModel.action.send(.didChangeSearchBarText(text))
            }
            .store(in: &cancellables)

        listView.tableView.didSelectRowPublisher
            .map(\.row)
            .sink { [weak self] row in
                self?.viewModel.action.send(.didTapCell(row))
            }
            .store(in: &cancellables)

        viewModel.state.filteredRates
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rates in
                let items = rates.map { ListItem.rate($0) }
                self?.updateSnapshot(with: items)
            }
            .store(in: &cancellables)

        viewModel.state.fetchError
            .sink { [weak self] _ in
                self?.showAlert(
                    title: Constant.Alert.title,
                    message: Constant.Alert.fetchErrorMessage
                )
            }
            .store(in: &cancellables)

        viewModel.state.hasMatches
            .receive(on: DispatchQueue.main)
            .sink { [weak self] has in
                self?.listView.isHiddenNoMatchLabel(hasMatch: has)
            }
            .store(in: &cancellables)

        viewModel.state.showDetailVC
            .receive(on: DispatchQueue.main)
            .sink { [weak self] detailVC in
                self?.navigationController?.pushViewController(detailVC, animated: true)
            }
            .store(in: &cancellables)
    }

    private func updateSnapshot(with items: [ListItem]) {
        var snapshot = NSDiffableDataSourceSnapshot<ListSection, ListItem>()
        snapshot.appendSections([.list])
        snapshot.appendItems(items, toSection: .list)
        dataSource?.apply(snapshot)
    }
}
