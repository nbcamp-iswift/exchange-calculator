import UIKit
import Combine
import Then

final class ExchangeRateCalculatorViewController: UIViewController {
    private let viewModel: ExchangeRateCalculatorViewModel
    private var cancellables = Set<AnyCancellable>()

    private lazy var currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 24, weight: .bold)
    }

    private lazy var countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .gray
    }

    private lazy var labelStackView = UIStackView(
        arrangedSubviews: [
            currencyLabel,
            countryLabel
        ]).then {
        $0.spacing = 4
        $0.axis = .vertical
        $0.alignment = .center
    }

    private lazy var amountTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.keyboardType = .decimalPad
        $0.textAlignment = .center
        $0.placeholder = "금액을 입력하세요"
    }

    private lazy var convertButton = UIButton().then {
        $0.backgroundColor = .systemBlue
        $0.setTitleColor(.white, for: .normal)
        $0.setTitle("환율 계산", for: .normal)
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(convertedTapped), for: .touchUpInside)
    }

    private lazy var resultLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    init(viewModel: ExchangeRateCalculatorViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    private func setAttributes() {
        view.backgroundColor = .systemBackground
        title = "환율 정보"
    }

    private func setHierarchy() {
        [
            labelStackView,
            amountTextField,
            convertButton,
            resultLabel
        ].forEach {
            view.addSubview($0)
        }
    }

    private func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(32) // 32
            make.centerX.equalToSuperview()
            make.height.equalTo(44)
        }

        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(44)
        }

        convertButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
            make.height.equalTo(44)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(convertButton.snp.bottom).offset(32)
            make.leading.equalToSuperview().offset(24)
            make.trailing.equalToSuperview().offset(-24)
        }
    }

    private func setBindings() {
        currencyLabel.text = viewModel.currency
        countryLabel.text = viewModel.countryName

        viewModel.$result
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                guard
                    let self,
                    let amountText = amountTextField.text,
                    let amount = Double(amountText),
                    !result.isEmpty else {
                    self?.resultLabel.text = nil
                    return
                }

                let formatted = String(
                    format: "$%.2f -> %@ %@",
                    amount,
                    result,
                    viewModel.currency
                )

                resultLabel.text = formatted
            }
            .store(in: &cancellables)
    }

    @objc private func convertedTapped() {
        guard let text = amountTextField.text,
              let amount = Double(text) else {
            resultLabel.text = "Please enter a valid amount"
            return
        }

        viewModel.convert(amount: amount)
    }
}
