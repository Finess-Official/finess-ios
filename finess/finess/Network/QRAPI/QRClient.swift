//
//  QRClient.swift
//  finess
//
//  Created by Elina Karapetyan on 23.04.2025.
//

import Foundation

protocol QRClient {
    func request<DTO: Decodable, Domain>(
        with params: QRAPI,
        map: @escaping (DTO) -> Domain,
        completion: @escaping (Result<Domain, APIErrorHandler>) -> Void
    )
}

final class QRClientImpl: QRClient {
    private let client: URLSessionProtocol
    private let logger: APILoggingService

    init(client: URLSessionProtocol = URLSession.shared,
         logger: APILoggingService = APILoggingService()) {
        self.client = client
        self.logger = logger
    }

    func request<DTO: Decodable, Domain>(
        with params: QRAPI,
        map: @escaping (DTO) -> Domain,
        completion: @escaping (Result<Domain, APIErrorHandler>) -> Void
    ) {
        let result = createRequest(for: params)
        switch result {
        case .success(let request):
            let task = createDataTask(request: request, map: map, completion: completion)
            task.resume()
        case .failure(let error):
            completion(.failure(error).logFailure(using: logger))
        }
    }

    private func createDataTask<DTO: Decodable, Domain>(
        request: URLRequest,
        map: @escaping (DTO) -> Domain,
        completion: @escaping (Result<Domain, APIErrorHandler>) -> Void
    ) -> URLSessionDataTask {
        client.createDataTask(with: request) { [weak self] data, response, error in
            guard let self else { return }

            if let error = error as? URLError {
                let result: Result<Domain, APIErrorHandler> = {
                    switch error.code {
                    case .notConnectedToInternet,
                         .timedOut, .cannotFindHost,
                         .cannotConnectToHost, .networkConnectionLost,
                         .dnsLookupFailed, .secureConnectionFailed:
                        return .failure(.networkError)
                    default:
                        return .failure(.customApiError(CustomApiError(code: error.code.rawValue, message: error.localizedDescription)))
                    }
                }()
                completion(result.logFailure(using: logger))
                return
            }

            if let httpResponse = response as? HTTPURLResponse, !httpResponse.isSuccess {
                let result: Result<Domain, APIErrorHandler> = .failure(httpResponse.apiError)
                completion(result.logFailure(using: logger))
                return
            }

            guard let data = data else {
                completion(.failure(.internalServerError).logFailure(using: logger))
                return
            }

            do {
                let dto = try JSONDecoder().decode(DTO.self, from: data)
                let domain = map(dto)
                completion(.success(domain))
            } catch {
                completion(.failure(.decodingError).logFailure(using: logger))
            }
        }
    }


    private func createRequest(for params: QRAPI) -> Result<URLRequest, APIErrorHandler> {
        guard let url = URL(string: FinessApp.baseURL + FinessApp.Path.payment + params.path)
        else { return .failure(.badRequest).logFailure(using: logger) }

        guard let accessToken = Auth.shared.getCredentials().accessToken
        else { return .failure(.unauthorized).logFailure(using: logger) }

        var request = URLRequest(url: url)
        request.httpMethod = params.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        if case let .requestWithJSONBody(body) = params.action {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                return .failure(.decodingError).logFailure(using: logger)
            }
        }

        return .success(request)
    }
}


