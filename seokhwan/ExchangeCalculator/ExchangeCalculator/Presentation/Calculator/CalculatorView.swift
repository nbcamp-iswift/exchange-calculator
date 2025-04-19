import UIKit
import SnapKit

final class CalculatorView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    func update(with exchangeRate: ExchangeRate) {
        print(#function, exchangeRate.currency) // TODO: 기능 구현 후 해당 구문 제거
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

    func setHierarchy() {}

    func setConstraints() {}
}
