//
//  DetailViewController.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/19/25.
//

import UIKit

final class DetailViewController: UIViewController {
    // MARK: - Components

    private let detailView = DetailView()

    // MARK: - Life Cycles

    override func loadView() {
        view = detailView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
    }
}

// MARK: - Configure

extension DetailViewController {
    private func configure() {
        setAttributes()
    }

    private func setAttributes() {
        title = Constant.Title.exchangeCalc
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
