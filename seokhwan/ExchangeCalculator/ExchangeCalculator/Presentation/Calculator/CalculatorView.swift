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
