//
//  APIErrorHandler.swift
//  finess
//
//  Created by Elina Karapetyan on 12.04.2025.
//

import Foundation

struct ApiErrorDTO: Codable, Equatable {
    let code: String?
    let message: String?
    let errorItems: [String: String]?
}

enum APIErrorHandler: Error, Equatable {
    case customApiError(ApiErrorDTO)
    case badRequest
    case unauthorized
    case tooManyRequests
    case internalServerError
    case serviceUnavailable
    case unkownError

    var description: String {
        switch self {
        case .customApiError(let error):
            return "\(error)"
        case .badRequest:
            return "Неверный формат данных запроса"
        case .unauthorized:
            return "Аутентификация не удалась - сессия не найдена"
        case .tooManyRequests:
            return  "Слишком много запросов - превышен лимит"
        case .internalServerError:
            return "Внутренняя ошибка сервера - запрос не может быть обработан"
        case .serviceUnavailable:
            return "Сервис временно недоступен - попробуйте позже"
        case .unkownError:
            return "Неизвестная ошибка"
        }
    }
}
