//
//  HTTPURLResponse+Extensions.swift
//  finess
//
//  Created by Elina Karapetyan on 03.05.2025.
//

import Foundation

extension HTTPURLResponse {
    var apiError: APIErrorHandler {
        switch statusCode {
        case 400: return .badRequest
        case 401: return .unauthorized
        case 429: return .tooManyRequests
        case 500: return .internalServerError
        case 503: return .serviceUnavailable
        default:
            let fallbackMessage = HTTPURLResponse.localizedString(forStatusCode: statusCode)
            let customError = CustomApiError(code: statusCode, message: fallbackMessage)
            return .customApiError(customError)
        }
    }
}


extension HTTPURLResponse {
    var isSuccess: Bool {
        return (200...299).contains(statusCode)
    }
}
