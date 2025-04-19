import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        addSubviews(views)
    }

    func addSubviews(_ views: [UIView]) {
        views.forEach {
            addSubview($0)
        }
    }
}
