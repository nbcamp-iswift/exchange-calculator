//
//  ExchangeRateTableViewCell.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/16/25.
//

import UIKit
import SnapKit
import RxSwift

final class ExchangeRateTableViewCell: UITableViewCell {
    static let identifier: String = "ExchangeRateTableViewCell"

    var disposeBag = DisposeBag()

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        return stackView
    }()

    private let currencyCodeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: 14)
        return label
    }()

    private let exchangeRateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.font = .systemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()

    lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(.init(systemName: "star"), for: .normal)
        button.setImage(.init(systemName: "star.fill"), for: .selected)
        button.tintColor = .systemYellow

        return button
    }()

    let arrowLabel: UILabel = .init()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        bookmarkButton.isSelected = false
        arrowLabel.text = ""
    }

    func setupCell(item: ExchangeRate) {
        currencyCodeLabel.text = item.currencyCode
        exchangeRateLabel.text = item.value
        countryLabel.text = item.country
        bookmarkButton.isSelected = item.isBookmark

        switch item.arrowState {
        case .increase: arrowLabel.text = "🔼"
        case .decrease: arrowLabel.text = "🔽"
        case .none: arrowLabel.text = " "
        }
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

        [labelStackView, exchangeRateLabel, arrowLabel, bookmarkButton].forEach {
            contentView.addSubview($0)
        }
    }

    func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        exchangeRateLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            make.trailing.equalTo(arrowLabel.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
        }

        arrowLabel.snp.makeConstraints { make in
            make.trailing.equalTo(bookmarkButton.snp.leading).offset(-12)
            make.centerY.equalToSuperview()
        }

        bookmarkButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(32)
        }
    }
}
