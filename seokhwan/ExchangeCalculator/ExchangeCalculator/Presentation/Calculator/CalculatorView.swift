import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class CalculatorView: UIView {
    var didTapConvertButton = PublishRelay<String>()

    private let disposeBag = DisposeBag()

    private lazy var labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }

    private lazy var currencyLabel = UILabel().then {
        $0.font = .boldSystemFont(ofSize: 24)
    }

    private lazy var countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .gray
    }

    private lazy var amountTextField = UITextField().then {
        $0.borderStyle = .roundedRect
        $0.keyboardType = .decimalPad
        $0.textAlignment = .center
        $0.placeholder = "달러(USD)를 입력하세요"
    }

    private lazy var convertButton = UIButton().then {
        $0.backgroundColor = .systemBlue
        $0.setTitle("환율 계산", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 8
    }

    private lazy var resultLabel = UILabel().then {
        $0.text = "계산 결과가 여기에 표시됩니다"
        $0.font = .systemFont(ofSize: 20, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(exchangeRate: ExchangeRate) {
        currencyLabel.text = exchangeRate.currency
        countryLabel.text = exchangeRate.country
    }

    func update(result: Double) {
        let amount = Double(amountTextField.text ?? "") ?? 0.0
        let formattedAmount = String(format: "%.2f", amount)
        let formattedResult = String(format: "%.2f", result)
        let currency = currencyLabel.text ?? ""

        resultLabel.text = "$\(formattedAmount) → \(formattedResult) \(currency)"
        amountTextField.text = ""
    }
}

private extension CalculatorView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
        setBindings()
    }

    func setAttributes() {
        backgroundColor = .background
    }

    func setHierarchy() {
        labelStackView.addArrangedSubviews(currencyLabel, countryLabel)
        addSubviews(labelStackView, amountTextField, convertButton, resultLabel)
    }

    func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(32)
            make.centerX.equalToSuperview()
        }

        amountTextField.snp.makeConstraints { make in
            make.top.equalTo(labelStackView.snp.bottom).offset(32)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        convertButton.snp.makeConstraints { make in
            make.top.equalTo(amountTextField.snp.bottom).offset(24)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }

        resultLabel.snp.makeConstraints { make in
            make.top.equalTo(convertButton.snp.bottom).offset(32)
            make.directionalHorizontalEdges.equalToSuperview().inset(24)
        }
    }

    func setBindings() {
        convertButton.rx.tap
            .map { [weak self] in
                self?.amountTextField.text?.trimmingCharacters(in: .whitespaces) ?? ""
            }
            .bind(to: didTapConvertButton)
            .disposed(by: disposeBag)
    }
}
