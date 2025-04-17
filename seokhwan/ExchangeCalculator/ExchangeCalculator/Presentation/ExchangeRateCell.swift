import UIKit
import SnapKit

final class ExchangeRateCell: UITableViewCell {
    private lazy var labelStackView = UIStackView().configure {
        $0.axis = .vertical
        $0.spacing = 4
    }

    private lazy var currencyLabel = UILabel().configure {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }

    private lazy var countryLabel = UILabel().configure {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
    }

    private lazy var rateLabel = UILabel().configure {
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .right
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with exchangeRate: ExchangeRate) {
        currencyLabel.text = exchangeRate.currencyCode
        countryLabel.text = CountryNameMapper.countryName(from: exchangeRate.currencyCode)
        rateLabel.text = String(format: "%.4f", exchangeRate.rate)
    }
}

private extension ExchangeRateCell {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        labelStackView.addArrangedSubviews(currencyLabel, countryLabel)
        addSubviews(labelStackView, rateLabel)
    }

    func setConstraints() {
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(60)
        }

        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
        }
    }
}
