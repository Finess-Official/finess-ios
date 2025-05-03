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

    static func createQR(
        params: CreateQRParams
    ) -> QRAPI {
        return QRAPI(
            method: .post,
            path: "/qrcodes",
            action: .requestWithJSONBody(params)
        )
    }
}
