//
//  MainView.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/15/25.
//

import UIKit
import SnapKit

final class MainView: UIView {

    lazy var searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
        return searchBar
    }()

    lazy var exchangeTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 60
        tableView.separatorStyle = .none
        tableView.register(
            ExchangeRateTableViewCell.self,
            forCellReuseIdentifier: ExchangeRateTableViewCell.identifier
        )
        return tableView
    }()

    lazy var emptyLabel: UILabel = {
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
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        exchangeTableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
