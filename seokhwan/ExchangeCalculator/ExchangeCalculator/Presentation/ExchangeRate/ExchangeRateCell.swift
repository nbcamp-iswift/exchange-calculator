import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

final class ExchangeRateCell: UITableViewCell {
    private var disposeBag = DisposeBag()

    private lazy var labelStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 4
    }

    private lazy var currencyLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16, weight: .medium)
    }

    private lazy var countryLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 14)
        $0.textColor = .gray
    }

    private lazy var rateLabel = UILabel().then {
        $0.font = .systemFont(ofSize: 16)
        $0.textAlignment = .right
    }

    private lazy var favoriteButton = UIButton(type: .system).then {
        $0.tintColor = .systemYellow
    }

    override init(style: CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func update(with exchangeRate: ExchangeRate) {
        currencyLabel.text = exchangeRate.currency
        countryLabel.text = exchangeRate.country
        rateLabel.text = String(format: "%.4f", exchangeRate.value)

        let imageName = exchangeRate.isFavorite ? "star.fill" : "star"
        favoriteButton.setImage(.init(systemName: imageName), for: .normal)
    }

    func bind(to relay: PublishRelay<String>) {
        favoriteButton.rx.tap
            .map { [weak self] in
                self?.currencyLabel.text ?? ""
            }
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
}

private extension ExchangeRateCell {
    func configure() {
        setHierarchy()
        setConstraints()
    }

    func setHierarchy() {
        labelStackView.addArrangedSubviews(currencyLabel, countryLabel)
        contentView.addSubviews(labelStackView, rateLabel, favoriteButton)
    }

    func setConstraints() {
        labelStackView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }

        rateLabel.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(labelStackView.snp.trailing).offset(16)
            make.centerY.equalToSuperview()
            make.width.equalTo(120)
        }

        favoriteButton.snp.makeConstraints { make in
            make.leading.equalTo(rateLabel.snp.trailing).offset(16)
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
