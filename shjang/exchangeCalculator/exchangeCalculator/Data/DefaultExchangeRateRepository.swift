import Foundation

enum ExchangeRateError: Error {
    case inValidURL
    case decodeFailed
    case networkError(Error)
}

extension ExchangeRateError: LocalizedError {
    private var errorDescription: String {
        switch self {
        case .inValidURL: return "Invalid URL"
        case .decodeFailed: return "Decode failed"
        case let .networkError(error): return "Network error: \(error.localizedDescription)"
        }
    }
}

final class DefaultExchangeRateRepository: ExchangeRateRepository {
    private var appConfiguration: AppConfiguration

    init(appConfiguration: AppConfiguration) {
        self.appConfiguration = appConfiguration
    }

    func fetch(
        baseCurrency _: String,
        completion: @escaping (Result<[ExchangeRate], Error>) -> Void
    ) {
        guard let url = URL(string: appConfiguration.apiBaseURL) else {
            completion(.failure(ExchangeRateError.inValidURL))
            return
        }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error {
                completion(.failure(ExchangeRateError.networkError(error)))
                return
            }

            guard let data,
                  let dto = try? JSONDecoder().decode(ExchangeRateDto.self, from: data) else {
                completion(.failure(ExchangeRateError.decodeFailed))
                return
            }

            let domainModel = ExchangeRateMapper.map(dto: dto)
            completion(.success(domainModel))
        }.resume()
    }
}
