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
        detailView.convertButton.tapPublisher
            .sink { [weak self] _ in
                self?.viewModel.convert(amount: self?.detailView.amountTextField.text)
            }
            .store(in: &cancellables)

        viewModel.exchangeRate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                guard let self, let rate else { return }
                detailView.updateView(for: rate)
            }
            .store(in: &cancellables)

        viewModel.convertedResultText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.detailView.updateResultLabel(for: result)
            }
            .store(in: &cancellables)

        viewModel.inputError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.showAlert(
                    title: Constant.Alert.title,
                    message: Constant.Alert.emptyInputErrorMessage
                )
            }
            .store(in: &cancellables)

        viewModel.invalidNumberFormatError
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.showAlert(
                    title: Constant.Alert.title,
                    message: Constant.Alert.invalidNumberErrorMessage
                )
            }
            .store(in: &cancellables)
    }
}
