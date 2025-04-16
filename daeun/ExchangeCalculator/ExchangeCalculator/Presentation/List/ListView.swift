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

    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.register(ListCell.self, forCellReuseIdentifier: ListCell.reuseIdentifier)
        tableView.separatorStyle = .none
        return tableView
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
        setHierachy()
        setConstraints()
    }

    private func setHierachy() {
        [tableView].forEach { addSubview($0) }
    }

    private func setConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
