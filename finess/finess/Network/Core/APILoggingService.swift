//
//  LoggingService.swift
//  finess
//
//  Created by Elina Karapetyan on 03.05.2025.
//

import Foundation
import Logging

final class APILoggingService {
    private let logger = Logger(label: "com.finess.apierror")

    func log(error: APIErrorHandler) {
        logger.error("\(loggingMessage(for: error))")
    }

    func loggingMessage(for error: APIErrorHandler) -> String {
        switch error {
        case .customApiError(let error):
            let title = NSLocalizedString("developerLogUnkownError", comment: "")
            let code = error?.code ?? .zero
            let message = error?.message ?? ""
            return String(format: "%@: Code %d, Message: %@", title, code, message)
        case .badRequest:
            return NSLocalizedString("developerLogBadRequest", comment: "")
        case .unauthorized:
            return NSLocalizedString("developerLogUnauthorized", comment: "")
        case .tooManyRequests:
            return  NSLocalizedString("developerLogTooManyRequests", comment: "")
        case .internalServerError:
            return NSLocalizedString("developerLogInternalServerError", comment: "")
        case .serviceUnavailable:
            return NSLocalizedString("developerLogServiceUnavailable", comment: "")
        case .networkError:
            return NSLocalizedString("developerLogNetworkError", comment: "")
        case .decodingError:
            return NSLocalizedString("developerLogDecodingError", comment: "")
        }
    }
}
