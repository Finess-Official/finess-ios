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

    init(client: URLSessionProtocol = URLSession.shared) {
        self.client = client
    }

    func request(
        with params: QRAPI,
        completion: @escaping (Result<CreateAccountResponse, APIErrorHandler>) -> Void
    ) {
        guard let request = createRequest(for: params) else {
            completion(.failure(.badRequest))
            return
        }

        let task = client.createDataTask(with: request) { data, response, error in
            if let error = error {
                print("Network error: \(error.localizedDescription)")
                completion(.failure(.internalServerError))
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if let errorStatus = self.handleHTTPStatusCode(httpResponse.statusCode) {
                    completion(.failure(errorStatus))
                }
            }

            guard let data = data else {
                completion(.failure(.internalServerError))
                return
            }

            let decoder = JSONDecoder()

            do {
                let result = try decoder.decode(CreateAccountResult.self, from: data)
                let response = QRDTOToDomainConverter.convert(from: result)
                completion(.success(response))
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(.failure(.internalServerError))
            }
        }

        task.resume()
    }

    private func createRequest(for params: QRAPI) -> URLRequest? {
        guard let url = URL(string: FinessApp.baseURL + FinessApp.Path.payment + params.path),
        let accessToken = Auth.shared.getCredentials().accessToken else {
            return nil
        }

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
                return nil
            }
        }

        return request
    }

    private func handleHTTPStatusCode(_ statusCode: Int) -> APIErrorHandler? {
        switch statusCode {
        case 200:
            return nil
        case 400:
            return .badRequest
        case 401:
            return .unauthorized
        case 429:
            return .tooManyRequests
        case 500:
            return .internalServerError
        case 503:
            return .serviceUnavailable
        default:
            return .unkownError
        }
    }
}

