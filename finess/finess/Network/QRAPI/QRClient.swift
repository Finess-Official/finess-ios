//
//  QRClient.swift
//  finess
//
//  Created by Elina Karapetyan on 23.04.2025.
//

import Foundation

protocol QRClient: AnyObject {
    func request(
        with params: QRAPI,
        completion: @escaping (
            _ result: Result<CreateAccountResponse, APIErrorHandler>
        ) -> Void
    )
}

final class QRClientImpl: QRClient {
    
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
        with params: QRAPI,
        completion: @escaping (Result<CreateAccountResponse, APIErrorHandler>) -> Void
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

    private func createDataTask(request: URLRequest, completion: @escaping (Result<CreateAccountResponse, APIErrorHandler>) -> Void) -> URLSessionDataTask {
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

            do {
                let result = try decoder.decode(CreateAccountResult.self, from: data)
                let response = QRDTOToDomainConverter.convert(from: result)
                completion(.success(response))
            } catch {
                completion(.failure(.decodingError).logFailure(using: logger))
            }
        }
    }

    private func createRequest(for params: QRAPI) -> Result<URLRequest, APIErrorHandler> {
        guard let url = URL(string: FinessApp.baseURL + FinessApp.Path.payment + params.path)
        else { return .failure(APIErrorHandler.badRequest).logFailure(using: logger) }

        guard let accessToken = Auth.shared.getCredentials().accessToken
        else { return .failure(APIErrorHandler.unauthorized).logFailure(using: logger) }

        var request = URLRequest(url: url)
        request.httpMethod = params.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        switch params.action {
        case .request:
            break
        case let .requestWithJSONBody(body):
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                return .failure(APIErrorHandler.decodingError).logFailure(using: logger)
            }
        }

        return .success(request)
    }
}

