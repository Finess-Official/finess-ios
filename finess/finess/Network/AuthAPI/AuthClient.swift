//
//  AuthClient.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import Foundation

enum AuthError: Error {
    case jsonParseError
}

protocol AuthClient: AnyObject {
    func request(
        client _: URLSessionProtocol,
        with params: AuthAPI,
        completion: @escaping (
            _ result: Result<AuthResponse, APIErrorHandler>
        ) -> Void
    )
}

final class AuthClientImpl: AuthClient {

    func request(
        client: URLSessionProtocol,
        with params: AuthAPI,
        completion: @escaping (Result<AuthResponse, APIErrorHandler>) -> Void
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
            decoder.dateDecodingStrategy = .iso8601WithFractionalSeconds
            do {
                let result = try decoder.decode(AuthResult.self, from: data)
                let response = AuthDTOToDomainConverter.convert(from: result)
                completion(.success(response))
            } catch {
                print("Error parsing JSON: \(error.localizedDescription)")
                completion(.failure(.internalServerError))
            }
        }

        task.resume()
    }
    
    private func createRequest(for params: AuthAPI) -> URLRequest? {
        guard let url = URL(string: FinessApp.baseURL + FinessApp.Path.identity + params.path) else {
            return nil
        }

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

