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

    private var disposeBag: DisposeBag = .init()

    private let mainView: MainView = .init()

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

        title = "환율 정보"
        navigationItem.largeTitleDisplayMode = .always
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    private func setBindings() {
        viewModel.action.accept(.fetchExchangeRates)

        setBindingFilteredExchangeRates()
        setBindingError()
        setBindingSearchBar()
        setBindingTableView()
    }

    private func setBindingFilteredExchangeRates() {
        viewModel.state
            .map(\.filteredExchangeRate)
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: [])
            .drive(
                mainView.exchangeTableView.rx.items(
                    cellIdentifier: ExchangeRateTableViewCell.identifier,
                    cellType: ExchangeRateTableViewCell.self
                )
            ) { _, item, cell in
                cell.setupCell(item: item)
            }
            .disposed(by: disposeBag)

        viewModel.state
            .map(\.filteredExchangeRate)
            .distinctUntilChanged()
            .map(\.isEmpty)
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] emptyItems in
                guard let self else { return }
                mainView.emptyLabel.isHidden = !emptyItems
            }.disposed(by: disposeBag)
    }

    private func setBindingTableView() {
        mainView.exchangeTableView.rx.itemSelected
            .asDriver(onErrorDriveWith: .empty())
            .drive { [weak self] indexPath in
                guard let self else { return }
                mainView.exchangeTableView.deselectRow(at: indexPath, animated: true)
                coordinator.showDetailView(
                    exchangeRate: viewModel.state.value.filteredExchangeRate[indexPath.row]
                )
            }.disposed(by: disposeBag)
    }

    private func setBindingSearchBar() {
        mainView.searchBar.rx.text
            .orEmpty
            .distinctUntilChanged()
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] text in
                guard let self else { return }
                viewModel.action.accept(.updateSearchBarText(text))
            }
            .disposed(by: disposeBag)

        mainView.searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                self?.mainView.searchBar.resignFirstResponder()
            })
            .disposed(by: disposeBag)
    }

    private func setBindingError() {
        viewModel.state
            .map(\.error)
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self else { return }
                showAlert()
            }
            .disposed(by: disposeBag)
    }
}
