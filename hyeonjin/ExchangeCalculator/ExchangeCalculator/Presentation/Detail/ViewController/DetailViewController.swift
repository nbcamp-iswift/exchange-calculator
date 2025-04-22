//
//  DetailViewController.swift
//  ExchangeCalculator
//
//  Created by 유현진 on 4/20/25.
//

import UIKit
import RxSwift
import RxCocoa

final class DetailViewController: UIViewController {
    private let viewModel: DetailViewModel

    private let disposeBag: DisposeBag = .init()

    private let detailView: DetailView = .init()

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

        setAttributes()
        setBindings()
        hideKeyboardWhenTouchUpBackground()
    }

    private func showAlert(error: ConvertError) {
        let alert = UIAlertController(
            title: "오류",
            message: error.rawValue,
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension DetailViewController {
    private func setAttributes() {
        view.backgroundColor = .systemBackground

        title = "환율 계산기"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setBindings() {
        viewModel.state
            .map(\.exchangeRate)
            .distinctUntilChanged()
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] exchangeRate in
                guard let self else { return }
                detailView.currencyLabel.text = exchangeRate.currencyCode
                detailView.countryLabel.text = exchangeRate.country
            }
            .disposed(by: disposeBag)

        detailView.amountTextField.rx
            .text
            .orEmpty
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] amount in
                guard let self else { return }
                viewModel.action.accept(.updateAmount(amount))
            }
            .disposed(by: disposeBag)

        detailView.convertButton.rx
            .tap
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] _ in
                guard let self else { return }
                viewModel.action.accept(.tappedConvertButton)
            }
            .disposed(by: disposeBag)

        viewModel.state
            .map(\.convertedResult)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive(detailView.resultLabel.rx.text)
            .disposed(by: disposeBag)

        viewModel.state
            .map(\.error)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] error in
                guard let self else { return }
                showAlert(error: error)
                viewModel.action.accept(.resetErrorState)
            }
            .disposed(by: disposeBag)
    }
}
