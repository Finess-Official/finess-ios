//
//  QRAPI.swift
//  finess
//
//  Created by Elina Karapetyan on 23.04.2025.
//

import Foundation

struct QRAPI: APIProvider {
    var path: String
    var queryParameters: URLEncodable
    var headers: [Header]
    var method: EndpointMethod
    var action: EndpointAction

    private init(
        method: EndpointMethod,
        path: String,
        queryParameters: URLEncodable = [:],
        action: EndpointAction,
        headers: [Header] = []
    ) {
        self.method = method
        self.path = path
        self.queryParameters = queryParameters
        self.action = action
        self.headers = headers
    }
}

extension QRAPI {
    static func createAccount(
        params: CreateAccountParams
    ) -> QRAPI {
        return QRAPI(
            method: .post,
            path: "/accounts",
            action: .requestWithJSONBody(params)
        )
    }

    static func getAccount(accountId: String) -> QRAPI {
        return QRAPI(
            method: .get,
            path: "/accounts/\(accountId)",
            action: .request
        )
    }

    static func createQR(
        params: CreateQRParams
    ) -> QRAPI {
        return QRAPI(
            method: .post,
            path: "/qrcodes",
            action: .requestWithJSONBody(params)
        )
    }

    static func getQR(qrCodeId: String) -> QRAPI {
        return QRAPI(
            method: .get,
            path: "/qrcodes/\(qrCodeId)",
            action: .request
        )
    }

    static func initPaymentQR(params: PaymentCreationParamsQR) -> QRAPI {
        return QRAPI(
            method: .post,
            path: "/payments:init",
            action: .requestWithJSONBody(params)
        )
    }

    static func initPaymentBeacon(params: PaymentCreationParamsBeacon) -> QRAPI {
        return QRAPI(
            method: .post,
            path: "/payments:init",
            action: .requestWithJSONBody(params)
        )
    }

    static func getInitStatus(paymentId: String) -> QRAPI {
        return QRAPI(
            method: .get,
            path: "/payments/initializations/\(paymentId)",
            action: .request
        )
    }
}
