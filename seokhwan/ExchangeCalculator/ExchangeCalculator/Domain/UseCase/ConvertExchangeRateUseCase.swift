import Foundation

final class ConvertExchangeRateUseCase {
    func execute(input: String, rate: Double) -> Result<Double, ExchangeRateError> {
        guard !input.isEmpty else { return .failure(.emptyInput) }
        guard let amount = Double(input) else { return .failure(.invalidInput) }

        return .success(amount * rate)
    }
}
