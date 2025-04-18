import UIKit

final class NavigationController: UINavigationController {
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
