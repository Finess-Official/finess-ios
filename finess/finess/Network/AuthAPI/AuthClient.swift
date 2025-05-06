//
//  AuthClient.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import Foundation

protocol AuthClient: AnyObject {
    func request(
        with params: AuthAPI,
        completion: @escaping (
            _ result: Result<AuthResponse, APIErrorHandler>
        ) -> Void
    )
}

final class AuthClientImpl: AuthClient {

    private let client: URLSessionProtocol
    private let logger: APILoggingService

    init(
        client: URLSessionProtocol = URLSession.shared,
        logger: APILoggingService = APILoggingService()
    ) {
        self.client = client
        self.logger = logger
    }

    func request(
        with params: AuthAPI,
        completion: @escaping (Result<AuthResponse, APIErrorHandler>) -> Void
    ) {
        let result = createRequest(for: params)
        switch result {
        case .success(let request):
            let task = createDataTask(request: request, completion: completion)
            task.resume()
        case .failure(let error):
            completion(.failure(error).logFailure(using: logger))
        }
    }

    private func createDataTask(request: URLRequest, completion: @escaping (Result<AuthResponse, APIErrorHandler>) -> Void) -> URLSessionDataTask {
        client.createDataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }
            if let error = error as? URLError {
                switch error.code {
                case .notConnectedToInternet,
                     .timedOut,
                     .cannotFindHost,
                     .cannotConnectToHost,
                     .networkConnectionLost,
                     .dnsLookupFailed,
                     .secureConnectionFailed:
                    completion(.failure(.networkError).logFailure(using: logger))
                default:
                    completion(.failure(.customApiError(CustomApiError(code: error.code.rawValue, message: error.localizedDescription))).logFailure(using: logger))
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.isSuccess else {
                    let errorStatus = httpResponse.apiError
                    completion(.failure(errorStatus).logFailure(using: logger))
                    return
                }
            }

            guard let data = data else {
                completion(.failure(.internalServerError).logFailure(using: logger))
                return
            }

            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601WithFractionalSeconds

            do {
                let result = try decoder.decode(AuthResult.self, from: data)
                let response = AuthDTOToDomainConverter.convert(from: result)
                completion(.success(response))
            } catch {
                completion(.failure(.decodingError).logFailure(using: logger))
            }
        }
    }

    private func createRequest(for params: AuthAPI) -> Result<URLRequest, APIErrorHandler> {
        guard let url = URL(string: FinessApp.baseURL + FinessApp.Path.identity + params.path)
        else { return .failure(.badRequest).logFailure(using: logger) }

        var request = URLRequest(url: url)
        request.httpMethod = params.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        switch params.action {
        case .request:
            break
        case let .requestWithJSONBody(body):
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                return .failure(.decodingError).logFailure(using: logger)
            }
        }

        return .success(request)
    }
}


