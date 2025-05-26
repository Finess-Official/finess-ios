//
//  AccountsInfoDTOToDomainConverter.swift
//  finess
//
//  Created by Elina Karapetyan on 26.05.2025.
//

import Foundation

struct AccountsInfoDTOToDomainConverter {
    static func convert(_ dto: [CreateAccountResult]) -> AccountsInfoResponse {
        var accounts: [CreateAccountResponse] = []

        dto.forEach { account in
            accounts.append(AccountDTOToDomainConverter.convert(from: account))
        }
        return AccountsInfoResponse(
            accounts: accounts
        )
    }
}
