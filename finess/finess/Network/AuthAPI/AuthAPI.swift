//
//  AuthAPI.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import Foundation

struct AuthAPI: APIProvider {
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

extension AuthAPI {
    static func signUp(
        params: SignUpParams
    ) -> AuthAPI {
        return AuthAPI(
            method: .post,
            path: "/users",
            action: .requestWithJSONBody(params)
        )
    }

    static func signIn(
        params: SignInParams
    ) -> AuthAPI {
        return AuthAPI(
            method: .post,
            path: "/tokens",
            action: .requestWithJSONBody(params)
        )
    }
}
