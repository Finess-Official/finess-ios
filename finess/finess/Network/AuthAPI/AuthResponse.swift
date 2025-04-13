//
//  AuthSignUpResponse.swift
//  finess
//
//  Created by Elina Karapetyan on 06.04.2025.
//

import Foundation

struct AuthResponse {
    let accessToken: String
    let sessionExpiresAt: Date
    let refreshToken: String
    let refreshTokenExpiresAt: Date
    let userId: String
}
