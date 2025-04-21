import UIKit
import Then
import Combine

final class ExchangeRateTableViewCell: UITableViewCell {
    static let identifier: String = "ExchangeRateTableViewCell"
    var onFavoriteTapped: (() -> Void)?
    private var cancellable: AnyCancellable?

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

    private lazy var directionImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
    }

    private lazy var rateDirectionStackView = UIStackView(
        arrangedSubviews: [rateLabel, directionImageView]
    ).then {
        $0.axis = .horizontal
        $0.spacing = 4
        $0.alignment = .center
    }

    private lazy var starButton = UIButton().then {
        $0.setImage(UIImage(systemName: "star"), for: .normal)
        $0.tintColor = .systemYellow
        $0.addTarget(self, action: #selector(handleFavoriteButtonTapped), for: .touchUpInside)
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
        contentView.addSubview(rateDirectionStackView)
        contentView.addSubview(starButton)
    }

    private func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }

        directionImageView.snp.makeConstraints { make in
            make.width.equalTo(16)
            make.height.equalTo(16)
        }

        rateDirectionStackView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
        }

        starButton.snp.makeConstraints { make in
            make.leading.equalTo(rateDirectionStackView.snp.trailing).offset(8)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
    }

    func update(with viewModel: ExchangeRateTableViewCellModel) {
        currencyLabel.text = viewModel.title
        countryLabel.text = viewModel.subtitle
        rateLabel.text = viewModel.trailingText
        let starIcon = viewModel.isFavorite ? "star.fill" : "star"
        starButton.setImage(UIImage(systemName: starIcon), for: .normal)

        switch viewModel.direction {
        case .up:
            directionImageView.image = UIImage(systemName: "arrow.up")
            directionImageView.isHidden = false
        case .down:
            directionImageView.image = UIImage(systemName: "arrow.down")
            directionImageView.isHidden = false
        case nil:
            directionImageView.isHidden = true
        }
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func setHighlighted(_ highlighted: Bool, animated: Bool) {
        super.setHighlighted(highlighted, animated: animated)
        contentView.backgroundColor = highlighted ? Const.pressedColor : Const.backgroundColor
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        onFavoriteTapped = nil
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

    @objc private func handleFavoriteButtonTapped() {
        onFavoriteTapped?()
    }
}
