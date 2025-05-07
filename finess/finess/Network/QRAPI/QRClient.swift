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

    init(
        client: URLSessionProtocol = URLSession.shared
    ) {
        self.client = client
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
            completion(.failure(error))
        }
    }

    private func createDataTask<DTO: Decodable, Domain>(
        request: URLRequest,
        map: @escaping (DTO) -> Domain,
        completion: @escaping (Result<Domain, APIErrorHandler>) -> Void
    ) -> URLSessionDataTask {
        client.createDataTask(with: request) { data, response, error in
            if let error = error as? URLError {
                switch error.code {
                case .notConnectedToInternet,
                     .timedOut,
                     .cannotFindHost,
                     .cannotConnectToHost,
                     .networkConnectionLost,
                     .dnsLookupFailed,
                     .secureConnectionFailed:
                    completion(.failure(.networkError))
                default:
                    completion(.failure(.customApiError(CustomApiError(code: error.code.rawValue, message: error.localizedDescription))))
                }
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.isSuccess else {
                    let errorStatus = httpResponse.apiError
                    completion(.failure(errorStatus))
                    return
                }
            }

            guard let data = data else {
                completion(.failure(.internalServerError))
                return
            }

            do {
                let dto = try JSONDecoder().decode(DTO.self, from: data)
                let domain = map(dto)
                completion(.success(domain))
            } catch {
                completion(.failure(.decodingError))
            }
        }
    }


    private func createRequest(for params: QRAPI) -> Result<URLRequest, APIErrorHandler> {
        guard let url = URL(string: FinessApp.baseURL + FinessApp.Path.payment + params.path)
        else { return .failure(APIErrorHandler.badRequest) }

        guard let accessToken = Auth.shared.getCredentials().accessToken
        else { return .failure(APIErrorHandler.unauthorized) }

        var request = URLRequest(url: url)
        request.httpMethod = params.method.rawValue
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")

        if case let .requestWithJSONBody(body) = params.action {
            do {
                request.httpBody = try JSONEncoder().encode(body)
            } catch {
                return .failure(APIErrorHandler.decodingError)
            }
        }

        return .success(request)
    }
}


