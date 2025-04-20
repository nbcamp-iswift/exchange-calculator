//
//  UIViewController+Extensions.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/17/25.
//

import UIKit

extension UIViewController {
    func hideKeyboardWhenTouchUpBackground() {
        let tap = UITapGestureRecognizer(
            target: self,
            action: #selector(UIViewController.dismissKeyboard)
        )
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
