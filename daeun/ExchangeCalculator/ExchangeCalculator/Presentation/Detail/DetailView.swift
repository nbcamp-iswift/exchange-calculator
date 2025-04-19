//
//  DetailView.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/19/25.
//

import UIKit
import SnapKit

final class DetailView: UIView {
    typealias Spacing = Constant.Spacing
    typealias FontSize = Constant.FontSize

    // MARK: - Components

    private let labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = Spacing.labelStack
        stackView.alignment = .center
        return stackView
    }()

    private let currencyLabel: UILabel = {
        let label = UILabel()
        label.text = "KRW"
        label.font = .systemFont(ofSize: FontSize.extraLarge, weight: .bold)
        return label
    }()

    private let countryLabel: UILabel = {
        let label = UILabel()
        label.text = "대한민국"
        label.font = .systemFont(ofSize: FontSize.medium)
        label.textColor = .gray
        return label
    }()

    private let amountTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        textField.textAlignment = .center
        textField.placeholder = Constant.Text.typeAmount
        return textField
    }()

    private let convertButton: UIButton = {
        let button = UIButton()
        var config = UIButton.Configuration.filled()
        config.attributedTitle = AttributedString(
            Constant.Text.calcExchange,
            attributes: .init([
                .font: UIFont.systemFont(ofSize: FontSize.medium, weight: .medium),
            ])
        )
        config.background.cornerRadius = Constant.Config.buttonCornerRadius
        button.configuration = config
        return button
    }()

    private let resultLabel: UILabel = {
        let label = UILabel()
        label.text = Constant.Text.calcResult
        label.font = .systemFont(ofSize: FontSize.large, weight: .medium)
        label.textAlignment = .center
        return label
    }()

    // MARK: - Life Cycles

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

// MARK: - Configure

extension DetailView {
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
            labelStackView,
            amountTextField,
            convertButton,
            resultLabel,
        ].forEach { addSubview($0) }

        [
            currencyLabel,
            countryLabel,
        ].forEach { labelStackView.addArrangedSubview($0) }
    }

    private func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(Spacing.detailvertical)
            make.centerX.equalToSuperview()
        }

        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(Spacing.detailvertical)
            make.directionalHorizontalEdges.equalToSuperview().inset(Spacing.detailHorizontal)
            make.height.equalTo(Constant.Size.fieldHeight)
        }

        convertButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(Spacing.elementVertical)
            make.directionalHorizontalEdges.equalToSuperview().inset(Spacing.detailHorizontal)
            make.height.equalTo(Constant.Size.fieldHeight)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(convertButton.snp.bottom).offset(Spacing.detailvertical)
            make.directionalHorizontalEdges.equalToSuperview().inset(Spacing.detailHorizontal)
        }
    }
}
