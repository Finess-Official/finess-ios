//
//  QRCodeConverter.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import Foundation

struct QRCodeConverter {
    enum Constants {
        static let deeplinkScheme = "finess"
        static let deeplinkHost = "payment"
        static let accountId = "accountId"
    }

    func convert(code: QRCodeCaptureSession.QRCode) -> String? {
        if let accountId = deeplinkConverter(codeValue: code.value) {
            return accountId
        }
        return nil
    }

    private func deeplinkConverter(codeValue: String) -> String? {
        guard let qrURL = URL(string: codeValue),
            let accountId = qrURL.params[Constants.accountId]
        else {
            return nil
        }

        guard let scheme = qrURL.scheme,
            let host = qrURL.host
        else { return nil }

        if scheme == Constants.deeplinkScheme && host == Constants.deeplinkHost {
            return accountId
        }
        return nil
    }
}
