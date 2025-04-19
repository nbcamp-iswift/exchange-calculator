import UIKit
import Combine
import SnapKit

final class CalculatorView: UIView {
    private var convertButtonDidTapSubject = PassthroughSubject<String, Never>()
    private var cancellables = Set<AnyCancellable>()

    var convertButtonDidTapPublisher: AnyPublisher<String, Never> {
        convertButtonDidTapSubject.eraseToAnyPublisher()
    }

    private lazy var labelStackView = UIStackView().configure {
        $0.axis = .vertical
        $0.spacing = 4
        $0.alignment = .center
    }

    private lazy var currencyLabel = UILabel().configure {
        $0.font = .boldSystemFont(ofSize: 24)
    }

    private lazy var countryLabel = UILabel().configure {
        $0.font = .systemFont(ofSize: 16)
        $0.textColor = .gray
    }

    private lazy var amountTextField = UITextField().configure {
        $0.borderStyle = .roundedRect
        $0.keyboardType = .decimalPad
        $0.textAlignment = .center
        $0.placeholder = "금액을 입력하세요"
    }

    private lazy var convertButton = UIButton().configure {
        $0.backgroundColor = .systemBlue
        $0.setTitle("환율 계산", for: .normal)
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(convertButtonDidTap), for: .touchUpInside)
    }

    private lazy var resultLabel = UILabel().configure {
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
        resultLabel.text = "\(result)"
    }

    @objc
    func convertButtonDidTap() {
        defer {
            amountTextField.text = ""
        }

        guard let text = amountTextField.text else { return }
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)

        convertButtonDidTapSubject.send(trimmedText)
    }
}

private extension CalculatorView {
    func configure() {
        setAttributes()
        setHierarchy()
        setConstraints()
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
}
