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

    var disposeBag: DisposeBag = DisposeBag()

    private lazy var mainView: MainView = {
        return MainView()
    }()

    let viewModel = MainViewModel()

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        setBindings()
    }

    private func setAttributes() {
        view.backgroundColor = .systemBackground
    }

    private func setBindings() {
        viewModel.exchangeRates
            .bind(
                to: mainView.exchangeTableView.rx.items(
                    cellIdentifier: ExchangeRateTableViewCell.identifier,
                    cellType: ExchangeRateTableViewCell.self
                )
            ) { (_, item, cell) in
                cell.setupCell(item: item)
            }.disposed(by: self.disposeBag)

        viewModel.errorSubject
            .compactMap { $0 }
            .observe(on: MainScheduler.instance)
            .subscribe { [weak self] _ in
                self?.showAlert()
            }.disposed(by: self.disposeBag)
    }

    private func showAlert() {
        let alert = UIAlertController(
            title: "오류",
            message: "데이터를 불러올 수 없습니다.",
            preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default))
        present(alert, animated: true)
    }
}
