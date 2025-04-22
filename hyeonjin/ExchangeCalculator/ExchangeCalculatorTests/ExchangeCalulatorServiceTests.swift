//
//  ExchangeCalulatorServiceTests.swift
//  ExchangeCalculatorTests
//
//  Created by 유현진 on 4/16/25.
//

@testable import ExchangeCalculator
import XCTest
import RxSwift

final class ExchangeCalculatorServiceTests: XCTestCase {
    var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    func test_fetchExchangeRate_returnMockData() {
        let expectation = XCTestExpectation(description: "환율 정보 가져오기 완료")
        let networkManage = ExchangeRateRepository(service: MockReturnResponseDataSerivce())

        networkManage.fetchExchangeRates()
            .subscribe { result in
                switch result {
                case .success(let data):
                    XCTAssertEqual(data.count, 3)
                case .failure(let error):
                    XCTFail("not fail, but got error: \(error)")
                }

                expectation.fulfill()
            }.disposed(by: disposeBag)

        wait(for: [expectation], timeout: 5.0)
    }

    func test_fetchExchangeRate_InvaildURL() async {
        let service = ExchangeRateService()

        do {
            _ = try await service.request(
                MockExchangeRateServiceType.testFetchExchangeRate
            ) as ExchangeRateReponseDTO
            XCTFail("Expected to throw invaildURL error, but succeeded")
        } catch let error as ExchangeRateServiceError {
            switch error {
            case .invaildURL:
                XCTAssert(true)
            default:
                XCTFail("Unexpected error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_fetchExchangeRate_StatusCodeError() async {
        let service = MockFailStatusCodeService()

        do {
            _ = try await service.request(
                ExchangeRateServiceType.fetchExchangeRate
            ) as ExchangeRateReponseDTO
            XCTFail("Expected to throw statusCodeError error, but succeeded")
        } catch let error as ExchangeRateServiceError {
            switch error {
            case .statusCodeError(let code):
                XCTAssertEqual(code, 404)
            default:
                XCTFail("Unexpected error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }

    func test_fetchExchangeRate_DecodingError() async {
        let service = MockDecodingErrorService()

        do {
            _ = try await service.request(
                MockExchangeRateServiceType.testFetchExchangeRate
            ) as ExchangeRateReponseDTO
            XCTFail("Expected to throw statusCodeError error, but succeeded")
        } catch let error as ExchangeRateServiceError {
            switch error {
            case .decodingError:
                XCTAssertTrue(true)
            default:
                XCTFail("Unexpected error: \(error)")
            }
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
