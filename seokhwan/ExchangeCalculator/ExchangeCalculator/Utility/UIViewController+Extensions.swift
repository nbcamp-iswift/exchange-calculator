import UIKit

extension UIViewController {
    func presentErrorAlert(with message: String) {
        let alert = UIAlertController(title: "오류", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .cancel))

        present(alert, animated: true)
    }
}
