//
//  AuthSignUpResult.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import Foundation

struct AuthResult: Decodable {
    struct Attributes: Decodable {
        struct User: Decodable {
            let id: String
        }

        let user: User
    }

    let sessionToken: String
    let sessionExpiresAt: Date
    let refreshToken: String
    let refreshTokenExpiresAt: Date
    let attributes: Attributes
}
