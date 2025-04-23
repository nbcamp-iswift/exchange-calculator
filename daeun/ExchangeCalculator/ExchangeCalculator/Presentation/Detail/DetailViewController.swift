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
        navigationController?.navigationBar.backItem?.title = Constant.Title.exchangeInfo
        navigationController?.navigationBar.prefersLargeTitles = true
        setTapGestureToDismissKeyboard()
    }

    private func setBindings() {
        detailView.convertButton.tapPublisher
            .sink { [weak self] _ in
                let text = self?.detailView.amountTextField.text
                self?.viewModel.action.send(.didTapConvertButton(text))
            }
            .store(in: &cancellables)

        viewModel.state.exchangeRate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                guard let self, let rate else { return }
                detailView.updateView(for: rate)
            }
            .store(in: &cancellables)

        viewModel.state.convertedResultText
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                self?.detailView.updateResultLabel(for: result)
            }
            .store(in: &cancellables)

        viewModel.state.errorMessage
            .sink { [weak self] message in
                self?.showAlert(title: Constant.Alert.title, message: message)
            }
            .store(in: &cancellables)
    }
}
