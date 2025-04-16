//
//  ExchangeCalulatorServiceTests.swift
//  ExchangeCalulatorTests
//
//  Created by 유현진 on 4/16/25.
//

@testable import ExchangeCalulator
import XCTest
import RxSwift

final class ExchangeCalulatorServiceTests: XCTestCase {
    var disposeBag: DisposeBag!
    var networkManage: NetworkManager!

    override func setUp() {
        super.setUp()
        networkManage = NetworkManager(service: MockExchangeRateSerivce())
        disposeBag = DisposeBag()
    }


    func test_fetchExchangeRate_returnMockData() {
        let expectation = XCTestExpectation(description: "환율 정보 가져오기 완료")

        networkManage.fetchExchangeRates()
            .subscribe{ result in
                switch result {
                case .success(let data):
                    XCTAssertEqual(data.count, 3)
                case .failure(let error):
                    XCTFail("not fail, but got error: \(error)")
                }

                expectation.fulfill()
            }.disposed(by: self.disposeBag)

        wait(for: [expectation], timeout: 5.0)
    }
}
