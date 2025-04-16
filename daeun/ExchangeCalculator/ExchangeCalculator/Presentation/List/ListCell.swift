//
//  ListCell.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import SnapKit
import UIKit

final class ListCell: UITableViewCell, ReuseIdentifying {
    // MARK: - Components

    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        return label
    }()

    // MARK: - Life Cycles

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: Methods

extension ListCell {
    private func configure() {
        setHierachy()
        setConstraints()
    }

    private func setHierachy() {
        [currencyCodeLabel, exchangeRateLabel].forEach { addSubview($0) }
    }

    private func setConstraints() {
        currencyCodeLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constant.Spacing.cellVertical)
            make.leading.equalToSuperview().inset(Constant.Spacing.cellHorizontal)
        }

        exchangeRateLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(Constant.Spacing.cellVertical)
            make.trailing.equalToSuperview().inset(Constant.Spacing.cellHorizontal)
        }
    }

    func updateCell(for data: ExchangeRate) {
        currencyCodeLabel.text = data.code
        exchangeRateLabel.text = String(data.rate)
    }
}
