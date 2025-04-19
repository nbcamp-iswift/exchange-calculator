//
//  MainViewController.swift
//  ExchangeCalulator
//
//  Created by 유현진 on 4/14/25.
//

import UIKit
import RxSwift
import RxCocoa

final class MainViewController: UIViewController {
    let coordinator: Coordinator
    private let viewModel: MainViewModel

    var disposeBag: DisposeBag = .init()

    private lazy var mainView: MainView = .init()

    init(viewModel: MainViewModel, coordinator: Coordinator) {
        self.viewModel = viewModel
        self.coordinator = coordinator
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        setBindings()
        hideKeyboardWhenTouchUpBackground()
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "오류",
            message: "데이터를 불러올 수 없습니다.",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}

extension MainViewController {
    private func setAttributes() {
        view.backgroundColor = .systemBackground
    }

    private func setBindings() {
        viewModel.filteredExchangeRates
            .bind(
                to: mainView.exchangeTableView.rx.items(
                    cellIdentifier: ExchangeRateTableViewCell.identifier,
                    cellType: ExchangeRateTableViewCell.self
                )
            ) { _, item, cell in
                cell.setupCell(item: item)
            }
            .disposed(by: disposeBag)

        viewModel.filteredExchangeRates
            .map(\.isEmpty)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] emptyItems in
                guard let self else { return }
                mainView.emptyLabel.isHidden = !emptyItems
            }.disposed(by: disposeBag)

        viewModel.errorSubject
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self else { return }
                showAlert()
            }
            .disposed(by: disposeBag)

        mainView.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .subscribe { [weak self] text in
                guard let self else { return }
                viewModel.searchBarText.accept(text)
            }
            .disposed(by: disposeBag)
    }
}
