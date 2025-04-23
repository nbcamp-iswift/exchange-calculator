//
//  ListCell.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/16/25.
//

import SnapKit
import UIKit
import Combine

final class ListCell: UITableViewCell, ReuseIdentifying {
    // MARK: - Properties

    let isSelectedFavoriteButton = PassthroughSubject<Bool, Never>()
    var cancellables = Set<AnyCancellable>()

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
        label.textColor = .secondaryLabel
        label.font = .systemFont(ofSize: Constant.FontSize.small)
        return label
    }()

    private let rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: Constant.FontSize.medium)
        label.textAlignment = .right
        return label
    }()

    private let fluctuationLabel = UILabel()

    private let favoriteButton: UIButton = {
        let button = UIButton()
        button.configuration?.contentInsets = .zero
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.setImage(UIImage(systemName: "star.fill"), for: .selected)
        button.tintColor = .systemYellow
        return button
    }()

    override func prepareForReuse() {
        super.prepareForReuse()
        cancellables.removeAll()
        setBindings()
    }

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
        setBindings()
    }

    private func setHierachy() {
        [
            labelStackView,
            rateLabel,
            fluctuationLabel,
            favoriteButton,
        ].forEach { contentView.addSubview($0) }

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
            make.centerY.equalToSuperview()
            make.width.equalTo(Constant.Size.rateLabelWidth)
        }

        fluctuationLabel.snp.makeConstraints { make in
            make.leading
                .equalTo(rateLabel.snp.trailing)
                .offset(Constant.Spacing.cellHorizontal)
            make.centerY.equalToSuperview()
        }

        favoriteButton.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.leading
                .equalTo(fluctuationLabel.snp.trailing)
                .offset(Constant.Spacing.cellHorizontal)
            make.trailing.equalToSuperview().inset(Constant.Spacing.cellHorizontal)
            make.width.equalTo(favoriteButton.snp.height).multipliedBy(2.0 / 3.0)
        }
    }

    private func setBindings() {
        favoriteButton.tapPublisher
            .sink { [weak self] _ in
                guard let self else { return }
                isSelectedFavoriteButton.send(!favoriteButton.isSelected)
            }
            .store(in: &cancellables)
    }

    func updateCell(for data: ExchangeRate) {
        currencyLabel.text = data.currencyCode
        countryLabel.text = data.countryName
        rateLabel.text = String(data.value)
        fluctuationLabel.isHidden = abs(data.value - data.lastValue) <= 0.01
        fluctuationLabel.text = data.value > data.lastValue ? "📈" : "📉"
        favoriteButton.isSelected = data.favorited
    }
}
