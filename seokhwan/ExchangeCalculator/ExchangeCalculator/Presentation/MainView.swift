import UIKit

final class MainView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}

private extension MainView {
    func configure() {
        setAttributes()
    }

    func setAttributes() {
        backgroundColor = .background
    }
}
