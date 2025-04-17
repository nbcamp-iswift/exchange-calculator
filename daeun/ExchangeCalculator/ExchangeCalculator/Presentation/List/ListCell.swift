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

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Constant.Spacing.labelStack
        return stackView
    }()

    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.FontSize.medium, weight: .medium)
        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .gray
        label.font = .systemFont(ofSize: Constant.FontSize.small)
        return label
    }()

    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.FontSize.medium)
        label.textAlignment = .right
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
        setAttributes()
        setHierachy()
        setConstraints()
    }

    private func setAttributes() {
        selectionStyle = .none
    }

    private func setHierachy() {
        [
            labelStackView,
            rateLabel,
        ].forEach { addSubview($0) }

        [
            currencyLabel,
            countryLabel,
        ].forEach { labelStackView.addArrangedSubview($0) }
    }

    private func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(Constant.Spacing.cellHorizontal)
            make.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints { make in
            make.leading
                .greaterThanOrEqualTo(labelStackView.snp.trailing)
                .offset(Constant.Spacing.cellHorizontal)
            make.trailing.equalToSuperview().inset(Constant.Spacing.cellHorizontal)
            make.centerY.equalToSuperview()
            make.width.equalTo(Constant.Size.rateLabelWidth)
        }
    }

    func updateCell(for data: ExchangeRate, _ countryName: String) {
        currencyLabel.text = data.code
        countryLabel.text = countryName
        rateLabel.text = String(data.rate)
    }
}
