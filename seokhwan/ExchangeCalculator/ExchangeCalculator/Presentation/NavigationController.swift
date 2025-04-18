import UIKit

final class NavigationController: UINavigationController {
    init() {
        super.init(rootViewController: ExchangeRateViewController())
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

private extension NavigationController {
    func configure() {
        setAttributes()
    }

    func setAttributes() {
        navigationBar.prefersLargeTitles = true
    }
}
