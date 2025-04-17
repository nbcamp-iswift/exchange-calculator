import UIKit
import Then

final class ExchangeRateTableViewCell: UITableViewCell {
    static let identifier: String = "ExchangeRateTableViewCell"
    private enum Const {
        static let backgroundColor = UIColor.white
        static let pressedColor = UIColor.gray
    }

    private lazy var currencyLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }

    private lazy var countryLabel = UILabel().then {
        $0.textColor = .gray
        $0.font = .systemFont(ofSize: 14)
    }

    private lazy var labelStackView = UIStackView(
        arrangedSubviews: [currencyLabel, countryLabel]
    ).then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    private lazy var rateLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .right
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    private func configure() {
        setAttribute()
        setHierarchy()
        setConstraints()
    }

    private func setAttribute() {
        selectionStyle = .none
    }

    private func setHierarchy() {
        contentView.addSubview(labelStackView)
        contentView.addSubview(rateLabel)
    }

    private func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            make.width.equalTo(120)
        }
    }

    func update(with currency: String, with contryName: String, with rate: String) {
        currencyLabel.text = currency
        countryLabel.text = contryName
        rateLabel.text = rate
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentView.backgroundColor = highlighted ? Const.pressedColor : Const.backgroundColor
    }

    func animatedPressed(completion: @escaping () -> Void) {
        contentView.backgroundColor = Const.pressedColor
        UIView.animate(withDuration: 0.3, animations: {
            self.contentView.backgroundColor = Const.backgroundColor
            self.layoutIfNeeded()
        }, completion: { _ in
            completion()
        })
    }
}
