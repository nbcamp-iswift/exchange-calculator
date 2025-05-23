//
//  ListView.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import SnapKit
import UIKit
import Combine

final class ListView: UIView {
    // MARK: - Components

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.searchBarStyle = .minimal
        return searchBar
    }()

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
        tableView.rowHeight = Constant.Size.cellHeight
        return tableView
    }()

    private let noMatchLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.Text.noMatch
        label.textColor = .secondaryLabel
        label.isHidden = true
        return label
    }()

    // MARK: - Life Cycles

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError()
    }
}

// MARK: - Methods

extension ListView {
    private func configure() {
        setAttributes()
        setHierachy()
        setConstraints()
    }

    private func setAttributes() {
        backgroundColor = .systemBackground
    }

    private func setHierachy() {
        [
            searchBar,
            tableView,
            noMatchLabel,
        ].forEach { addSubview($0) }
    }

    private func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.directionalHorizontalEdges.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.directionalHorizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }

        noMatchLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func isHiddenNoMatchLabel(hasMatch: Bool) {
        noMatchLabel.isHidden = hasMatch
    }
}
