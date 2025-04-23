//
//  MainView.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/15/25.
//

import UIKit
import SnapKit

final class MainView: UIView {
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        searchBar.placeholder = "통화 검색"
        searchBar.searchTextField.enablesReturnKeyAutomatically = false
        searchBar.returnKeyType = .done
        return searchBar
    }()

    let exchangeTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.register(
            ExchangeRateTableViewCell.self,
            forCellReuseIdentifier: ExchangeRateTableViewCell.identifier
        )
        return tableView
    }()

    let emptyLabel: UILabel = {
        let label = UILabel()
        label.text = "검색 결과 없음"
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .center
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension MainView {
    private func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .systemBackground
        exchangeTableView.backgroundView = emptyLabel
    }

    func setHierarchy() {
        [searchBar, exchangeTableView].forEach {
            addSubview($0)
        }
    }

    func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }

        exchangeTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.leading.trailing.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
