//
//  ListView.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import SnapKit
import UIKit

final class ListView: UIView {
    // MARK: - Components

    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.backgroundImage = UIImage()
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
        label.textColor = .gray
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
        fatalError("init(coder:) has not been implemented")
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
        backgroundColor = .white
    }

    private func setHierachy() {
        [
            tableView,
            searchBar,
            noMatchLabel,
        ].forEach { addSubview($0) }
    }

    private func setConstraints() {
        searchBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide)
            make.horizontalEdges.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }

        noMatchLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    func isHiddenNoMatchLabel(hasMatch: Bool) {
        noMatchLabel.isHidden = hasMatch
    }
}
