//
//  DetailViewController.swift
//  ExchangeCalculator
//
//  Created by 곽다은 on 4/19/25.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {
    // MARK: - Components

    private let detailView = DetailView()

    // MARK: - Properties

    private let viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Life Cycles

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

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
        setBindings()
    }

    private func setAttributes() {
        title = Constant.Title.exchangeCalc
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setBindings() {
        viewModel.exchangeRate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                guard let self, let rate else { return }
                detailView.updateView(for: rate)
            }
            .store(in: &cancellables)
    }
}
