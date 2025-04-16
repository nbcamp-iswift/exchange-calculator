import UIKit
import Then

final class CustomTableViewCell: UITableViewCell {
    static let identifier: String = "CustomTableViewCell"
    private enum Const {
        static let backgroundColor = UIColor.white
        static let pressedColor = UIColor.gray
    }

    private lazy var currencyLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16, weight: .regular)
        $0.textAlignment = .left
    }

    private lazy var rateLabel = UILabel().then {
        $0.textColor = .black
        $0.font = .systemFont(ofSize: 16, weight: .regular)
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
        contentView.addSubview(currencyLabel)
        contentView.addSubview(rateLabel)
    }

    private func setConstraints() {
        currencyLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-16)
            make.centerY.equalToSuperview()
        }
    }

    func update(with currency: String, with rate: Double) {
        currencyLabel.text = currency
        rateLabel.text = String(format: "%.4f", rate)
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

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
