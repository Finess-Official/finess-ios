//
//  SignUpDTOToDomainConverter.swift
//  finess
//
//  Created by Elina Karapetyan on 10.04.2025.
//

import Foundation

struct AuthDTOToDomainConverter {
    static func convert(from dto: AuthResult) -> AuthResponse {
        return AuthResponse(
            accessToken: dto.sessionToken,
            sessionExpiresAt: dto.sessionExpiresAt,
            refreshToken: dto.refreshToken,
            refreshTokenExpiresAt: dto.refreshTokenExpiresAt,
            userId: dto.attributes.user.id
        )
    }
}
