//
//  APIErrorHandler.swift
//  finess
//
//  Created by Elina Karapetyan on 12.04.2025.
//

import Foundation
import Logging

struct CustomApiError: Codable, Equatable {
    let code: Int
    let message: String?
}

enum APIErrorHandler: Error, Equatable {
    case customApiError(CustomApiError?)
    case badRequest
    case unauthorized
    case tooManyRequests
    case internalServerError
    case serviceUnavailable
    case networkError
    case decodingError
}
