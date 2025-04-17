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

    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private lazy var currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private lazy var exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
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
        currencyCodeLabel.text = item.base
        exchangeRateLabel.text = item.value
        countryLabel.text = item.country
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
        [currencyCodeLabel, countryLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }

        [labelStackView, exchangeRateLabel].forEach {
            addSubview($0)
        }
    }

    func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        exchangeRateLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
        }
    }
}
