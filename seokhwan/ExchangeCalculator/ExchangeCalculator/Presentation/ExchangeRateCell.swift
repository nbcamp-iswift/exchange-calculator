import UIKit
import SnapKit

final class ExchangeRateCell: UITableViewCell {
    private lazy var currencyCodeLabel = UILabel()
    private lazy var rateLabel = UILabel()

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with exchangeRate: ExchangeRate) {
        currencyCodeLabel.text = exchangeRate.currencyCode
        rateLabel.text = String(format: "%.4f", exchangeRate.rate)
    }
}

private extension ExchangeRateCell {
    func configure() {
        addSubviews()
        setConstraints()
    }

    func addSubviews() {
        addSubviews(currencyCodeLabel, rateLabel)
    }

    func setConstraints() {
        currencyCodeLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
    }
}
