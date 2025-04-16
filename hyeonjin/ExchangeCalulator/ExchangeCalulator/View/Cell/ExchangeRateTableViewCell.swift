//
//  ExchangeRateTableViewCell.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/16/25.
//

import UIKit
import SnapKit

final class ExchangeRateTableViewCell: UITableViewCell {

    static let identifier: String = "ExchangeRateTableViewCell"

    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()

    private lazy var exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func setupCell(item: ExchangeRate) {
        countryLabel.text = item.base
        exchangeRateLabel.text = item.value
    }
}

private extension ExchangeRateTableViewCell {
    private func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .systemBackground
    }

    func setHierarchy() {
        [countryLabel, exchangeRateLabel].forEach {
            addSubview($0)
        }
    }

    func setConstraints() {
        countryLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.leading.equalToSuperview().inset(20)
        }

        exchangeRateLabel.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().inset(10)
            make.trailing.equalToSuperview().inset(20)
        }
    }
}
