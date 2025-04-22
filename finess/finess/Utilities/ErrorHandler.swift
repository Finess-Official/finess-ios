//
//  ErrorHandler.swift
//  finess
//
//  Created by Elina Karapetyan on 12.04.2025.
//

import UIKit

class ErrorHandler {
    static let shared = ErrorHandler()

    private init() {}

    func showError(_ error: APIErrorHandler, navigationController: UIViewController?) {
        let alertController = UIAlertController(title: "Ошибка", message: alertMessage(for: error), preferredStyle: .alert)
        let buttonOK = UIAlertAction(title: "ОК", style: .default)
        alertController.addAction(buttonOK)

        navigationController?.present(alertController, animated: true)
    }

    private func alertMessage(for error: APIErrorHandler) -> String? {
        switch error {
        case .customApiError(_):
            return "Произошла ошибка, попробуйте повторить"
        case .badRequest:
            return "Неверный формат пароля"
        case .unauthorized:
            return "Неверно введенные данные, попробуйте снова"
        case .tooManyRequests:
            return "Превышен лимит запросов"
        case .unkownError:
            return "Произошла неизвестная ошибка"
        case .internalServerError, .serviceUnavailable:
            return error.description
        }
    }
}
