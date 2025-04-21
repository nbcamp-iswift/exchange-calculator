//
//  UIViewController+Extensions.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/21/25.
//

import UIKit

extension UIViewController {
    func showAlert(title: String, message: String) {
        let alertView = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert
        )

        let confirmAction = UIAlertAction(title: Constant.Alert.confirm, style: .default)
        alertView.addAction(confirmAction)

        present(alertView, animated: true)
    }
}
