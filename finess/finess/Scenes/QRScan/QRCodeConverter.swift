//
//  QRCodeConverter.swift
//  finess
//
//  Created by Elina Karapetyan on 04.05.2025.
//

import Foundation
import FinessCamera

struct QRCodeConverter {
    enum Constants {
        static let deeplinkScheme = "finess"
        static let deeplinkHost = "payment-qr"
        static let qrCodeId = "qrCodeId"
    }

    func convert(code: QRCodeCaptureSession.QRCode) -> String? {
        if let qrCodeId = deeplinkConverter(codeValue: code.value) {
            return qrCodeId
        }
        return nil
    }

    private func deeplinkConverter(codeValue: String) -> String? {
        guard let qrURL = URL(string: codeValue),
            let qrCodeId = qrURL.params[Constants.qrCodeId]
        else {
            return nil
        }

        guard let scheme = qrURL.scheme,
            let host = qrURL.host
        else { return nil }

        if scheme == Constants.deeplinkScheme && host == Constants.deeplinkHost {
            return qrCodeId
        }
        return nil
    }
}
