//
//  AccountDTOToDomainConverter.swift
//  finess
//
//  Created by Elina Karapetyan on 23.04.2025.
//

import Foundation

struct AccountDTOToDomainConverter {
    static func convert(from dto: CreateAccountResult) -> CreateAccountResponse {
        return CreateAccountResponse(
            id: dto.id,
            ownerName: dto.ownerName,
            inn: dto.inn,
            bik: dto.bik,
            accountNumber: dto.accountNumber
        )
    }
}
