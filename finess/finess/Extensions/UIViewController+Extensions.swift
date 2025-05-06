//
//  UIViewController+Extensions.swift
//  finess
//
//  Created by Elina Karapetyan on 02.05.2025.
//

import UIKit

extension UIViewController {
    func showError(_ error: APIErrorHandler) {
        let alert = UIAlertController(
            title: NSLocalizedString("error", comment: ""),
            message: alertMessage(for: error),
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: NSLocalizedString("ok", comment: ""), style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func alertMessage(for error: APIErrorHandler) -> String? {
        switch error {
        case .badRequest:
            return NSLocalizedString("userMessageBadRequest", comment: "")
        case .unauthorized:
            return NSLocalizedString("userMessageUnauthorized", comment: "")
        case .tooManyRequests:
            return  NSLocalizedString("userMessageTooManyRequests", comment: "")
        case .internalServerError:
            return NSLocalizedString("userMessageInternalServerError", comment: "")
        case .serviceUnavailable:
            return NSLocalizedString("userMessageServiceUnavailable", comment: "")
        case .customApiError:
            return NSLocalizedString("userMessageUnkownError", comment: "")
        case .networkError:
            return NSLocalizedString("userMessageNetworkError", comment: "")
        case .decodingError:
            return NSLocalizedString("userMessageDecodingError", comment: "")
        }
    }
}

