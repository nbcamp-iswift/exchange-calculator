//
//  DetailView.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/20/25.
//

import UIKit
import SnapKit

final class DetailView: UIView {
    private lazy var labelStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.spacing = 4
        stackView.alignment = .center
        stackView.axis = .vertical
        return stackView
    }()

    lazy var currencyLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        return label
    }()

    lazy var countryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16)
        label.textColor = .secondaryLabel
        return label
    }()

    lazy var amountTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "금액을 입력하세요"
        textField.textAlignment = .center
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        return textField
    }()

    lazy var convertButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("환율 계산", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        return button
    }()

    lazy var resultLabel: UILabel = {
        let label = UILabel()
        label.text = "계산 결과가 여기에 표시됩니다"
        label.textColor = .label
        label.font = .systemFont(ofSize: 20, weight: .medium)
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension DetailView {
    private func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
    }

    func setAttributes() {
        backgroundColor = .systemBackground
    }

    func setHierarchy() {
        [currencyLabel, countryLabel].forEach {
            labelStackView.addArrangedSubview($0)
        }

        [labelStackView, amountTextField, convertButton, resultLabel].forEach {
            addSubview($0)
        }
    }

    func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(32)
            make.centerX.equalToSuperview()
        }

        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        convertButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(convertButton.snp.bottom).offset(32)
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
